import 'package:appdiet/data/models/Day_comments.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/presentation/pages/detail_day_comment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListDayCommentsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ListDayCommentsPage());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((JournalBloc bloc) => bloc.state);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocListener<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state.journalStateStatus == JournalStateStatus.modifyDayComment) {
          Navigator.of(context).push(DetailDayCommentsPage.route(state.dayComments));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Commentaires"),
        ),
        body: BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) =>
              state.journalStateStatus == JournalStateStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child: _ListDayComments(
                          listCommentaires: state.journal.mapCommentaires),
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            context.read<JournalBloc>().add(DayCommentsClicked(
                dayComments: DayComments.empty,
                journal: state.journal,
                user: user,
                date : state.date));
          },
        ),
      ),
    );
  }
}

class _ListDayComments extends StatelessWidget {
  const _ListDayComments({Key key, this.listCommentaires}) : super(key: key);

  final List<DayComments> listCommentaires;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _construcRepas(listCommentaires, context),
    );
  }

  _construcRepas(List<DayComments> listCommentaires, BuildContext context) {
    final state = context.select((JournalBloc bloc) => bloc.state);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return listCommentaires
        .map(
          (comment) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
              child: _DayComment(dayComment: comment),
              onTap: () {
                context.read<JournalBloc>().add(DayCommentsClicked(
                    dayComments: comment, journal: state.journal, user: user,date: state.date));
              },
            ),
          ),
        )
        .toList();
  }
}

class _DayComment extends StatelessWidget {
  const _DayComment({this.dayComment});

  final DayComments dayComment;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 70.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayComment.titre,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.grey,
                  size: 16.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(dayComment.heure)
              ],
            )
          ],
        ),
      ),
    );
  }
}
