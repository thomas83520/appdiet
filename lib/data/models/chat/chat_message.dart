import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage(
      {required this.messageContent,
      required this.senderId,
      required this.date});

  final String messageContent;
  final String senderId;
  final DateTime date;

  ChatMessage.fromJson(Map<String, dynamic> parsedJSON)
      : messageContent = parsedJSON['messageContent'],
        senderId = parsedJSON['senderId'],
        date = (parsedJSON['date'] as Timestamp).toDate();

  static ChatMessage fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return ChatMessage(
        messageContent: snapshot.get("messageContent"),
        senderId: snapshot.get("senderId"),
        date: snapshot.get("date"));
  }

  @override
  List<Object> get props => [messageContent, senderId, date];
}
