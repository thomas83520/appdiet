import 'package:appdiet/journal/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final comments = context
        .select((JournalBloc bloc) => bloc.state.journal.mapCommentaires);
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 90.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        width: double.infinity,
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Icon(
              Icons.comment,
              size: 40.0,
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Commentaires",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(children: _generateInfos(comments)),
                ]),
          ),
        ]),
      ),
    );
  }

  List<Widget> _generateInfos(List<dynamic> comments) {
    if (comments.isEmpty)
      return [
        Text(
          "Ajouter un repas",
          style: TextStyle(color: Colors.grey),
        ),
      ];
    else
      return comments
          .map((comment) => Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.grey,
                    size: 16.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(comment['heure'] + ' : ' + comment['titre']),
                ],
              ))
          .toList();
  }
}
