import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  ChatRepository({required User user})
      : _firestore =FirebaseFirestore.instance,
        _user = user;

  final FirebaseFirestore _firestore;
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

  Future<void> sendMessage(String content) async {
    await _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .add({
      "messageContent": content,
      "senderId" : _user.id,
      "date" : Timestamp.fromDate(DateTime.now()),
    });

     await _firestore
          .collection("patient")
          .doc(_user.id)
          .collection("nouveautes")
          .add({
        "patientId": _user.id,
        "patientName": _user.completeName,
        "type": "message",
        "dateAjout": DateTime.now(),
      });
  }

  String get docId => _user.id + "_" + _user.uidDiet;
}
