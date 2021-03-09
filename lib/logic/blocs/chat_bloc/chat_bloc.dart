import 'dart:async';

import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:appdiet/data/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({@required ChatRepository chatRepository})
      : assert(chatRepository != null),
        _chatRepository = chatRepository,
        super(ChatState.unknown()) {
    _streamSubscription = _chatRepository
        .streamMessage()
        .listen((messages) => add(ChatNewMessage(messages: messages)));
  }

  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatMessage>> _streamSubscription;
  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if(event is ChatNewMessage){
      yield ChatState.complete(event.messages);
    }
    if(event is MessageSend){
      _chatRepository.sendMessage(event.message);
    }
  }

  @override
  Future<void> close(){
    _streamSubscription?.cancel();
    return super.close();
  }
}
