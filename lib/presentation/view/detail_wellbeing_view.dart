import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/detailwellbeing_cubit/detailwellbeing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailWellbeingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final journal = context.select((JournalBloc bloc) => bloc.state.journal);
    final statejournal = context.select((JournalBloc bloc) => bloc.state);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return MultiBlocListener(
      listeners: [
        BlocListener<JournalBloc, JournalState>(
          listener: (context, journalstate) {
            if (journalstate.journalStateStatus ==
                JournalStateStatus.complete) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<DetailwellbeingCubit, DetailwellBeingState>(
            listener: (context, state) {
          if (state.status == SubmissionStatus.success &&
              statejournal.journalStateStatus != JournalStateStatus.complete) {
            context
                .read<JournalBloc>()
                .add(JournalUpdate(journal, statejournal.date, user));
            //Navigator.of(context).pop();
          }
        })
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) => BackButton(
              onPressed: () {
                context
                    .read<JournalBloc>()
                    .add(JournalUpdate(journal, statejournal.date, user));
              },
            ),
          ),
          title: InkWell(
            child: Text("Mood du jour"),
          ),
        ),
        body: BlocListener<DetailwellbeingCubit, DetailwellBeingState>(
          listener: (context, state) {
            if (state.status == SubmissionStatus.failure)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text("Une erreur est survenue"),
                ),
              );
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      _Stress(),
                      SizedBox(
                        height: 20,
                      ),
                      _Ballonnements(),
                      SizedBox(
                        height: 20,
                      ),
                      _Hydratation(),
                      SizedBox(
                        height: 20,
                      ),
                      _Transit(),
                      SizedBox(
                        height: 20,
                      ),
                      _Fatigue(),
                      SizedBox(
                        height: 20,
                      ),
                      _Sommeil(),
                      SizedBox(
                        height: 20,
                      ),
                      _Humeur(),
                      SizedBox(
                        height: 20,
                      ),
                      _ValidateButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wellBeing =
        context.select((DetailwellbeingCubit cubit) => cubit.state.wellBeing);
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
              "Stress :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Exprimez votre niveau de stress de la journée"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .stressChanged(value),
                      value: wellBeing.stress.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Ballonnements extends StatelessWidget {
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
              "Ballonnements :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Vous êtes-vous senti(e) ballonné(e) aujourd’hui ?"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .ballonnementsChanged(value),
                      value: state.wellBeing.ballonnements.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Hydratation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wellBeing =
        context.select((DetailwellbeingCubit cubit) => cubit.state.wellBeing);
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
              "Hydratation :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Avez-vous atteint au moins 1,5L d’eau dans la journée ? "),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .hydratationChanged(value),
                      value: wellBeing.hydratation.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Transit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wellBeing =
        context.select((DetailwellbeingCubit cubit) => cubit.state.wellBeing);
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
              "Transit :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Exprimez votre état de transit"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .transitChanged(value),
                      value: wellBeing.transit.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Fatigue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wellBeing =
        context.select((DetailwellbeingCubit cubit) => cubit.state.wellBeing);
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
              "Fatigue :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Étiez-vous fatiguez aujourd'hui"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .fatigueChanged(value),
                      value: wellBeing.fatigue.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Sommeil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wellBeing =
        context.select((DetailwellbeingCubit cubit) => cubit.state.wellBeing);
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
              "Sommeil :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Avez-vous bien dormi la nuit dernière ?"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .sommeilChanged(value),
                      value: wellBeing.sommeil.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Humeur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wellBeing =
        context.select((DetailwellbeingCubit cubit) => cubit.state.wellBeing);
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
              "Humeur :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Exprimez votre humeur de la journée"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) => context
                          .read<DetailwellbeingCubit>()
                          .humeurChanged(value),
                      value: wellBeing.humeur.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ValidateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailwellbeingCubit, DetailwellBeingState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return state.status == SubmissionStatus.loading
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  key: const Key('detailWellbeingForm_validate_raisedButton'),
                  child: const Text(
                    'Valider',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    onSurface: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () =>
                      context.read<DetailwellbeingCubit>().validateWellbeing(),
                ),
              );
      },
    );
  }
}
