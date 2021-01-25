import 'package:appdiet/authentication/authentication.dart';
import 'package:appdiet/journal/bloc/cubit/detailmeal_cubit.dart';
import 'package:appdiet/journal/repository/journal_repository.dart';
import 'package:appdiet/journal/repository/models/repas.dart';
import 'package:appdiet/journal/views/Meals/details_meal_view.dart';
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
    return BlocProvider(
      create: (_) => DetailmealCubit(
        date: "11_12_2020",
        journalRepository: JournalRepository(),
        user: user,
        repas: repas,
      ),
      child: DetailMealView(),
    );
  }
}
