import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage(
      {required this.messageContent,
      required this.senderId,
      required this.date,
      required this.type});

  final String messageContent;
  final String senderId;
  final DateTime date;
  final String type;

  ChatMessage.fromJson(Map<String, dynamic> parsedJSON)
      : messageContent = parsedJSON['messageContent'],
        senderId = parsedJSON['senderId'],
        date = (parsedJSON['date'] as Timestamp).toDate(),
        type = parsedJSON.containsKey("type") ? parsedJSON['type'] : "text";

  @override
  List<Object> get props => [messageContent, senderId, date, type];
}
