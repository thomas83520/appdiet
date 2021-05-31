import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:appdiet/data/repository/chat_repository.dart';
import 'package:appdiet/logic/blocs/chat_bloc/chat_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChatRepository extends Mock implements ChatRepository{}

// ignore: must_be_immutable
class MockChatMessage extends Mock implements ChatMessage{}

void main(){
ChatRepository chatRepository;
  setUp(() {
    chatRepository = MockChatRepository();
    when(chatRepository.streamMessage).thenAnswer(
      (_) => Stream.empty(),
    );
  });
  final messages = MockChatMessage();
  group('New message', () {
    test('initial state is unknown when stream is empty', () {
      expect(
        ChatBloc(chatRepository: chatRepository).state,
        ChatState.unknown(),
      );
    });
    blocTest('inital state is complete when stream return goal ', build: () {
      when(chatRepository.streamMessage).thenAnswer((_) => Stream<List<ChatMessage>>.value([messages]));
      return ChatBloc(chatRepository: chatRepository);
    }, expect: <ChatState>[ChatState.complete([messages])]);
  });

  group('Message send', () {
    blocTest('Should emit error when repository throw',
        build: () {
          when(chatRepository.sendMessage('message'))
              .thenThrow(Exception('oops'));
          return ChatBloc(chatRepository: chatRepository);
        },
        act: (ChatBloc bloc) async => bloc
            .add(MessageSend(message : 'message')),
        expect: <ChatState>[
          ChatState.error(),
        ]);
    
    blocTest('Should not emit when repository return void', build: (){
      when(chatRepository.sendMessage('message')).thenAnswer((_) => Future.value());
      return ChatBloc(chatRepository: chatRepository);
    },
    act: (ChatBloc bloc) async => bloc.add(MessageSend(message: 'message')),
    expect: <ChatState> []);
  });
}