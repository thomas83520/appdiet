import 'package:appdiet/data/models/chat/chat_message.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessageView extends StatelessWidget {
  const MessageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListMessage(
                  messages: state.messages,
                );
              },
            ),
            ChatInput(),
          ],
        ),
      ),
    );
  }
}

class ListMessage extends StatelessWidget {
  final List<ChatMessage> messages;

  const ListMessage({Key? key,required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: messages[index].senderId == user.id
                ? UserMessage(
                    content: messages[index].messageContent,
                    date: messages[index].date,
                  )
                : DietMessage(
                    content: messages[index].messageContent,
                    date: messages[index].date,
                  ),
          );
        },
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 80,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            /*GestureDetector(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),*/
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  context
                      .read<ChatBloc>()
                      .add(MessageSend(message: _controller.text));
                  _controller.clear();
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
                backgroundColor: theme.primaryColor,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DietMessage extends StatelessWidget {
  final String content;
  final DateTime date;

  const DietMessage({Key? key,required this.content,required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200),
            padding: EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            DateFormat('d/M/y').format(date),
            style: TextStyle(fontSize: 8),
          ),
        )
      ],
    );
  }
}

class UserMessage extends StatelessWidget {
  final String content;
  final DateTime date;

  const UserMessage({Key? key,required this.content,required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green[200]),
            padding: EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            DateFormat('d/M/y').format(date),
            style: TextStyle(fontSize: 8),
          ),
        )
      ],
    );
  }
}
