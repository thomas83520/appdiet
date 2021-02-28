import 'package:appdiet/data/models/repas.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/presentation/pages/details_meal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListMealPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ListMealPage());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((JournalBloc bloc) => bloc.state);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocListener<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state.journalStateStatus == JournalStateStatus.modifyRepas) {
          Navigator.of(context).push(DetailmealPage.route(state.repas));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Repas"),
        ),
        body: BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) =>
              state.journalStateStatus == JournalStateStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child: _ListRepas(listRepas: state.journal.mapRepas),
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            context.read<JournalBloc>().add(
                RepasClicked(repas: Repas.empty, journal: state.journal, user: user,date: state.date));
          },
        ),
      ),
    );
  }
}

class _ListRepas extends StatelessWidget {
  const _ListRepas({Key key, this.listRepas}) : super(key: key);

  final List<Repas> listRepas;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _construcRepas(listRepas, context),
    );
  }

  _construcRepas(List<Repas> listRepas, BuildContext context) {
    final state = context.select((JournalBloc bloc) => bloc.state);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return listRepas
        .map((meal) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(
                child: _Repas(repas: meal),
                onTap: () {
                  context.read<JournalBloc>().add(RepasClicked(
                      repas: meal, journal: state.journal, user: user,date: state.date));
                },
              ),
            ))
        .toList();
  }
}

class _Repas extends StatelessWidget {
  const _Repas({this.repas});

  final Repas repas;
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
                  repas.name,
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
                    Text(repas.heure)
                  ],
                )
              ],
            )));
  }
}
