import 'dart:io';

import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/detailmeal_cubit/detailmeal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

class DetailMealView extends StatelessWidget {
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
        BlocListener<DetailmealCubit, DetailmealState>(
            listener: (context, state) {
          if (state.status == SubmissionStatus.success &&
              statejournal.journalStateStatus != JournalStateStatus.complete) {
            context
                .read<JournalBloc>()
                .add(JournalUpdate(journal, statejournal.date, user));
            Navigator.of(context).pop();
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
          title: BlocBuilder<JournalBloc, JournalState>(
            builder: (context, state) => state.repas == Repas.empty
                ? Text("Nouveau Repas")
                : Text("Modifier repas : " + state.repas.name),
          ),
        ),
        body: BlocListener<DetailmealCubit, DetailmealState>(
          listener: (context, state) {
            if (state.status == SubmissionStatus.failure)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erreur dans l'ajout du repas")),
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
                      _Titre(),
                      SizedBox(
                        height: 20,
                      ),
                      _Photo(),
                      SizedBox(
                        height: 20,
                      ),
                      _Heure(),
                      SizedBox(
                        height: 20,
                      ),
                      _Contenu(),
                      SizedBox(
                        height: 20,
                      ),
                      _Before(),
                      SizedBox(
                        height: 20,
                      ),
                      _Satiete(),
                      SizedBox(
                        height: 20,
                      ),
                      _Commentaires(),
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

class _Titre extends StatelessWidget {
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
        child: Row(
          children: [
            Text(
              "Nom Repas:",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<DetailmealCubit, DetailmealState>(
                  builder: (context, state) {
                    return DropdownButton<String>(
                      value: state.repas.name == ''
                          ? 'Petit déjeuner'
                          : state.repas.name,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        context.read<DetailmealCubit>().nameChanged(newValue!);
                      },
                      items: <String>[
                        'Petit déjeuner',
                        'Déjeuner',
                        'Goûter',
                        'Diner'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ], /*TextFormField(
                  initialValue: repas.name,
                  key: const Key('signUpForm_nameRepasInput_textField'),
                  onChanged: (nameRepas) =>
                      context.read<DetailmealCubit>().nameChanged(nameRepas),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),*/
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailmealCubit, DetailmealState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            XFile? file =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file != null) context.read<DetailmealCubit>().fileChanged(file);
          },
          child: Material(
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
              child: Row(
                children: [
                  Text(
                    "Ajoutez une photo:",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  BlocBuilder<DetailmealCubit, DetailmealState>(
                    builder: (context, state) {
                      return Container(
                        height: 150,
                        width: 100,
                        color: Colors.transparent,
                        child: photo(state),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget photo(DetailmealState state) {
    if (state.photoUrl != '')
      return Image.network(state.photoUrl);
    else
      return state.file.path == ''
          ? Container()
          : Image.file(File(state.file.path));
  }
}

class _Heure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repas = context.select((DetailmealCubit cubit) => cubit.state.repas);
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: InkWell(
        onTap: () => DatePicker.showTimePicker(context,
            locale: LocaleType.fr,
            showTitleActions: true,
            showSecondsColumn: false, onChanged: (date) {
          context.read<DetailmealCubit>().timeChanged(date.hour, date.minute);
        }, onConfirm: (date) {
          context.read<DetailmealCubit>().timeChanged(date.hour, date.minute);
        }, currentTime: DateTime.now()),
        child: Container(
          constraints: BoxConstraints(minHeight: 70.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          width: double.infinity,
          child: Row(
            children: [
              Text(
                "Heure du repas:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<DetailmealCubit, DetailmealState>(
                    builder: (context, state) {
                      return state.repas.heure == Repas.empty.heure
                          ? Text("Cliquez pour ajouter l'heure du repas")
                          : Text(
                              repas.heure,
                              style: TextStyle(fontSize: 30),
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Contenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repas = context.select((DetailmealCubit cubit) => cubit.state.repas);
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
              "Contenu du repas :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              initialValue: repas.contenu,
              onChanged: (commentaire) =>
                  context.read<DetailmealCubit>().contenuChanged(commentaire),
              decoration: InputDecoration(
                  hintText: "Décrivez ce que vous avez mangé.."),
              minLines: 1,
              maxLines: 15,
            )
          ],
        ),
      ),
    );
  }
}

class _Before extends StatelessWidget {
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
              "Faim avant le repas :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Exprimez votre niveau de faim avant le repas"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.remove),
                BlocBuilder<DetailmealCubit, DetailmealState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) =>
                          context.read<DetailmealCubit>().beforeChanged(value),
                      value: state.repas.before.toDouble(),
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

class _Satiete extends StatelessWidget {
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
              "Satiété :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Avez-vous suffisement mangé ?"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(Icons.sentiment_very_dissatisfied),
                BlocBuilder<DetailmealCubit, DetailmealState>(
                  builder: (context, state) {
                    return Expanded(
                        child: Slider.adaptive(
                      onChanged: (value) =>
                          context.read<DetailmealCubit>().satieteChanged(value),
                      value: state.repas.satiete.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                    ));
                  },
                ),
                Icon(Icons.sentiment_very_satisfied)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Commentaires extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repas = context.select((DetailmealCubit cubit) => cubit.state.repas);
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
              "Commentaire :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              initialValue: repas.commentaire,
              onChanged: (commentaire) => context
                  .read<DetailmealCubit>()
                  .commentaireChanged(commentaire),
              decoration: InputDecoration(
                  hintText: "Décrivez comment vous vous sentez.."),
              minLines: 1,
              maxLines: 15,
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
    return BlocBuilder<DetailmealCubit, DetailmealState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return state.status == SubmissionStatus.loading
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                    key: const Key('detailmealForm_validate_raisedButton'),
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
                        context.read<DetailmealCubit>().validateRepas()),
              );
      },
    );
  }
}
