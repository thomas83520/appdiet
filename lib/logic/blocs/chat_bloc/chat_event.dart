part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatNewMessage extends ChatEvent{
  const ChatNewMessage({this.messages});

  final List<ChatMessage> messages;

  @override
  List<Object> get props => [];
}

class MessageSend extends ChatEvent{
  const MessageSend({this.message});

  final String message;

  @override
  List<Object> get props => [message];
}