import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatRepository {
  ChatRepository({FirebaseFirestore firestore, User user})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        assert(user != null && user != User.empty),
        _user = user;

  final FirebaseFirestore _firestore;
  final User _user;

  Stream<List<ChatMessage>> streamMessage() {
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
    return await _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .add({
      "messageContent": content,
      "senderId" : _user.id,
      "date" : DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()),
    });
  }

  String get docId => _user.id + "_" + _user.uidDiet;
}
