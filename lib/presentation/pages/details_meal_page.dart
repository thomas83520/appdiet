import 'package:appdiet/data/models/repas.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/detailmeal_cubit/detailmeal_cubit.dart';
import 'package:appdiet/presentation/view/details_meal_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailmealPage extends StatelessWidget {
static Route route(Repas repas) {
    return MaterialPageRoute<void>(
        builder: (_) => DetailmealPage(
              repas: repas,
            ));
  }
  final Repas repas;

  const DetailmealPage({Key key, @required this.repas}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    final date  = context.select((JournalBloc bloc ) => bloc.state.date);
    return BlocProvider(
      create: (_) => DetailmealCubit(
        date: date,
        journalRepository: JournalRepository(),
        user: user,
        repas: repas,
      ),
      child: DetailMealView(),
    );
  }
}
