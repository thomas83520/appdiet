import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Chat message', () {
    test('Chat message from JSon', () {
      expect(
          ChatMessage.fromJson({
            "date": "15-05-2021 17:52:35",
            "senderId": "senderId",
            "messageContent": "message content"
          }),
          ChatMessage(
              date: "15-05-2021 17:52",
              senderId: "senderId",
              messageContent: "message content"));
    });
  });
}
