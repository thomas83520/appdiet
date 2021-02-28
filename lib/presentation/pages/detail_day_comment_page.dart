import 'package:appdiet/data/models/Day_comments.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/detailday_comment_cubit/detail_day_comments_cubit.dart';
import 'package:appdiet/presentation/view/details_day_comment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailDayCommentsPage extends StatelessWidget {
static Route route(DayComments dayComments) {
    return MaterialPageRoute<void>(
        builder: (_) => DetailDayCommentsPage(
              dayComments: dayComments,
            ));
  }
  final DayComments dayComments;

  const DetailDayCommentsPage({Key key, @required this.dayComments}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    final date = context.select((JournalBloc bloc)=>bloc.state.date);
    return BlocProvider(
      create: (_) => DetailDayCommentsCubit(
        date: date,
        journalRepository: JournalRepository(),
        user: user,
        dayComments: dayComments,
      ),
      child: DetailDayCommentView(),
    );
  }
}