part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatNewMessage extends ChatEvent{
  const ChatNewMessage({required this.messages});

  final List<ChatMessage> messages;

  @override
  List<Object> get props => [];
}

class TextMessageSend extends ChatEvent{
  const TextMessageSend({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class ImageMessageSend extends ChatEvent{
  const ImageMessageSend({required this.file});

  final XFile file;

  @override
  List<Object> get props => [file];
}