import 'dart:async';
import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/journal.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc(
      {required JournalRepository journalRepository,
      required User user,
      required DateTime date})
      : _journalRepository = journalRepository,
        //_user = user,
        super(JournalState.initial(
            date,
            Journal(
                date: date,
                wellBeing: WellBeing.empty,
                mapCommentaires: [],
                mapRepas: []))) {
    on<JournalEvent>((event, emit) => mapEventToState(event, emit));
  }

  final JournalRepository _journalRepository;

  Future<void> mapEventToState(
      JournalEvent event, Emitter<JournalState> emit) async {
    if (event is JournalDateChange) {
      emit(JournalState.loading(
          event.date,
          Journal(
              date: event.date,
              wellBeing: WellBeing.empty,
              mapCommentaires: [],
              mapRepas: [])));
      try {
        Journal journal =
            await _journalRepository.journalByDate(event.date, event.user.id);
        emit(JournalState.complete(journal, event.date));
      } catch (e) {
        print("journal by date, date changed");
          print(e);
        emit(JournalState.fail(
            event.date,
            Journal(
                date: event.date,
                wellBeing: WellBeing.empty,
                mapCommentaires: [],
                mapRepas: [])));
      }
    } else if (event is JournalUpdate) {
      emit(JournalState.loading(
          event.date,
          Journal(
              date: event.date,
              wellBeing: WellBeing.empty,
              mapCommentaires: [],
              mapRepas: [])));
      try {
        Journal journal =
            await _journalRepository.journalByDate(event.date, event.user.id);
        emit(JournalState.complete(journal, event.date));
      } catch (e) {

        print("journal by date journal update");
          print(e);
        emit(JournalState.fail(
            event.date,
            Journal(
                date: event.date,
                wellBeing: WellBeing.empty,
                mapCommentaires: [],
                mapRepas: [])));
      }
    } else if (event is RepasClicked) {
      emit(JournalState.loading(
          event.date,
          Journal(
              date: event.date,
              wellBeing: WellBeing.empty,
              mapCommentaires: [],
              mapRepas: [])));
      if (event.repas == Repas.empty)
        emit(JournalState.modifyRepas(Repas.empty, event.journal, event.date));
      else {
        try {
          Repas repas = await _journalRepository.repasById(
              event.date, event.user.id, event.repas.id);
          emit(JournalState.modifyRepas(repas, event.journal, event.date));
        } catch (e) {

        print("journal by repas by id, repas clicked");
          print(e);
          emit(JournalState.fail(
              event.date,
              Journal(
                  date: event.date,
                  wellBeing: WellBeing.empty,
                  mapCommentaires: [],
                  mapRepas: [])));
        }
      }
    } else if (event is DayCommentsClicked) {
      emit(JournalState.loading(
          event.date,
          Journal(
              date: event.date,
              wellBeing: WellBeing.empty,
              mapCommentaires: [],
              mapRepas: [])));
      if (event.dayComments == DayComments.empty)
        emit(JournalState.modifyDayComment(
            DayComments.empty, event.journal, event.date));
      else {
        try {
          DayComments dayComments = await _journalRepository.commentsById(
              event.journal.date, event.user.id, event.dayComments.id);
          emit(JournalState.modifyDayComment(
              dayComments, event.journal, event.date));
        } catch (e) {

        print("comment by id");
          print(e);
          emit(JournalState.fail(
              event.date,
              Journal(
                  date: event.date,
                  wellBeing: WellBeing.empty,
                  mapCommentaires: [],
                  mapRepas: [])));
        }
      }
    } else if (event is WellBeingClicked) {
      emit(JournalState.loading(
          event.date,
          Journal(
              date: event.date,
              wellBeing: WellBeing.empty,
              mapCommentaires: [],
              mapRepas: [])));
      emit(JournalState.modifyWellBeing(
          event.wellBeing, event.journal, event.date));
    }
  }

  String dateformat(DateTime date) {
    String formattedDate = DateFormat('dd_MM_yyyy').format(date);
    return formattedDate;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
