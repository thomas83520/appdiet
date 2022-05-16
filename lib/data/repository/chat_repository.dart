import 'dart:io';

import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/logic/tools/stringformatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatRepository {
  ChatRepository({required User user})
      : _firestore =FirebaseFirestore.instance,
      _firebaseStorage = FirebaseStorage.instance,
        _user = user;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final User _user;

  Stream<List<ChatMessage>> get streamMessage {
    return _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .orderBy("date",descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ChatMessage.fromJson(document.data()))
            .toList());
  }

  Future<void> sendTextMessage(String content) async {
    await _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .add({
      "messageContent": content,
      "senderId" : _user.id,
      "type" : "text",
      "date" : Timestamp.fromDate(DateTime.now()),
    });

    //Dashboard diet
     await _firestore
          .collection("patient")
          .doc(_user.id)
          .collection("nouveautes")
          .add({
        "patientId": _user.id,
        "patientName": _user.completeName,
        "type": "NewMessage",
        "dateAjout": DateTime.now(),
      });
  }

  Future<void> sendImageMessage(XFile file) async {

    String url = await uploadPhoto(file.path, file.name);

    await _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .add({
      "messageContent": url,
      "senderId" : _user.id,
      "type" : "image",
      "date" : Timestamp.fromDate(DateTime.now()),
    });

    //Dashboard diet
     await _firestore
          .collection("patient")
          .doc(_user.id)
          .collection("nouveautes")
          .add({
        "patientId": _user.id,
        "patientName": _user.completeName,
        "type": "NewMessage",
        "dateAjout": DateTime.now(),
      });
  }

Future<String> uploadPhoto( String filePath, String fileName) async {
    File file = File(filePath);
    fileName = StringFormatter.removeDiacritics(fileName)
        .replaceAll(new RegExp(r'[^\w]+'), '_');
    Reference ref =
        _firebaseStorage.ref(_user.id + '/chat/' + fileName + '.png');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
  String get docId => _user.id + "_" + _user.uidDiet;
}
