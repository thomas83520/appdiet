part of 'chat_bloc.dart';

enum ChatStateStatus {
  loading,
  unknown,
  error,
  complete,
}

class ChatState extends Equatable {
  const ChatState._({this.messages= const [],this.status = ChatStateStatus.unknown});

  const ChatState.unknown() : this._(status : ChatStateStatus.unknown);

  const ChatState.loading() : this._(status : ChatStateStatus.loading);

  const ChatState.error() : this._(status : ChatStateStatus.error);

  const ChatState.complete(List<ChatMessage> messages) : this._(messages : messages, status : ChatStateStatus.complete);

  final List<ChatMessage> messages;
  final ChatStateStatus status;
  
  @override
  List<Object> get props => [messages,status];
}

