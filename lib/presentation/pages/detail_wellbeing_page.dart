import 'package:appdiet/data/models/wellbeing.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/detailwellbeing_cubit/detailwellbeing_cubit.dart';
import 'package:appdiet/presentation/view/detail_wellbeing_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailWellBeingPage extends StatelessWidget {
  static Route route(WellBeing wellBeing) {
    return MaterialPageRoute<void>(
        builder: (_) => DetailWellBeingPage(
              wellBeing: wellBeing,
            ));
  }
  final WellBeing wellBeing;


  const DetailWellBeingPage({Key key, @required this.wellBeing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    final date = context.select((JournalBloc bloc) => bloc.state.date);
    return BlocProvider(
      create: (_) => DetailwellbeingCubit(
        date: date,
        journalRepository: JournalRepository(),
        user: user,
        wellBeing: wellBeing,
      ),
      child: DetailWellbeingView(),
    );
  }
}