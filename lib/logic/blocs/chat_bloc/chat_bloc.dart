import 'dart:async';

import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:appdiet/data/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatState.unknown()) {
    _streamSubscription = _chatRepository.streamMessage
        .listen((messages) => add(ChatNewMessage(messages: messages)));
        on<ChatEvent>((event,emit)=>mapEventToState(event,emit));
  }

  final ChatRepository _chatRepository;
  late StreamSubscription<List<ChatMessage>> _streamSubscription;

  Future<void> mapEventToState(
    ChatEvent event,Emitter<ChatState> emit
  ) async {
    if (event is ChatNewMessage) {
      emit(ChatState.complete(event.messages));
    }
    if (event is MessageSend) {
      try {
        await _chatRepository.sendMessage(event.message);
      } catch (e) {
        emit(ChatState.error());
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
