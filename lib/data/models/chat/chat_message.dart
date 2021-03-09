import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({this.messageContent, this.senderId, this.date});

  final String messageContent;
  final String senderId;
  final String date;

  ChatMessage.fromJson(Map<String, dynamic> parsedJSON)
      : messageContent = parsedJSON['messageContent'],
        senderId = parsedJSON['senderId'],
        date = parsedJSON['date'].substring(0,parsedJSON['date'].length-3);

  static ChatMessage fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return ChatMessage(
        messageContent: snapshot.get("messageContent"),
        senderId: snapshot.get("senderId"),
        date: snapshot.get("date"));
  }

  @override
  List<Object> get props => [messageContent, senderId,date];
}
