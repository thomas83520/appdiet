import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Meals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meals =
        context.select((JournalBloc bloc) => bloc.state.journal.mapRepas);
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
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
                Icons.restaurant,
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
                      "Repas",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(children: _generateInfos(meals)),
                  ]),
            ),
          ]),
        ),
      );
    });
  }

  List<Widget> _generateInfos(List<Repas> meals) {
    if (meals.isEmpty)
      return [
        Text(
          "Ajoutez un repas",
          style: TextStyle(color: Colors.grey),
        ),
      ];
    return meals
        .map((meal) => Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.grey,
                  size: 16.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(meal.heure + ' : ' + meal.name),
              ],
            ))
        .toList();
  }
}
