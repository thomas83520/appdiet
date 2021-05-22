import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:appdiet/logic/cubits/detailday_comment_cubit/detail_day_comments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DetailDayCommentView extends StatelessWidget {
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
        BlocListener<DetailDayCommentsCubit, DetailDayCommentsState>(
            listener: (context, state) {
          if (state.status == SubmissionStatus.success &&
              statejournal.journalStateStatus != JournalStateStatus.complete) {
            context
                .read<JournalBloc>()
                .add(JournalUpdate(journal, journal.date, user));
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
          title: InkWell(
              child: BlocBuilder<JournalBloc, JournalState>(
            builder: (context, state) => state.dayComments == DayComments.empty
                ? Text("Nouveau Commentaire")
                : Text("Modifier Commentaire : " + state.dayComments.titre),
          )),
        ),
        body: BlocListener<DetailDayCommentsCubit, DetailDayCommentsState>(
          listener: (context, state) {
            if (state.status == SubmissionStatus.failure)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erreur dans l'ajout du commentaire")),
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
                      _Heure(),
                      SizedBox(
                        height: 20,
                      ),
                      _Contenu(),
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
    final dayComments = context
        .select((DetailDayCommentsCubit cubit) => cubit.state.dayComments);
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
              "Titre commentaire:",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: dayComments.titre,
                  key: const Key('signUpForm_nameRepasInput_textField'),
                  onChanged: (nameRepas) => context
                      .read<DetailDayCommentsCubit>()
                      .nameChanged(nameRepas),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dayComments = context
        .select((DetailDayCommentsCubit cubit) => cubit.state.dayComments);
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: InkWell(
        onTap: () => DatePicker.showTimePicker(context,
            showTitleActions: true,
            showSecondsColumn: false, onChanged: (date) {
          context
              .read<DetailDayCommentsCubit>()
              .timeChanged(date.hour, date.minute);
        }, onConfirm: (date) {
          context
              .read<DetailDayCommentsCubit>()
              .timeChanged(date.hour, date.minute);
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
                "Heure:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<DetailDayCommentsCubit,
                      DetailDayCommentsState>(
                    builder: (context, state) {
                      return state.dayComments.heure == DayComments.empty.heure
                          ? Text("Cliquez pour ajouter l'heure du commentaire")
                          : Text(
                              dayComments.heure,
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
    final dayComments = context
        .select((DetailDayCommentsCubit cubit) => cubit.state.dayComments);
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
              "Contenu du commentaire :",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              initialValue: dayComments.contenu,
              onChanged: (commentaire) => context
                  .read<DetailDayCommentsCubit>()
                  .contenuChanged(commentaire),
              decoration:
                  InputDecoration(hintText: "Ecrivez votre commentaire.."),
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
    return BlocBuilder<DetailDayCommentsCubit, DetailDayCommentsState>(
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
                    onPrimary: theme.primaryColor,
                    onSurface: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () => context
                      .read<DetailDayCommentsCubit>()
                      .validateDayComments(),
                ),
              );
      },
    );
  }
}
