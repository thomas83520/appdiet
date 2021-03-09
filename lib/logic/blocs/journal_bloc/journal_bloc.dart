import 'dart:async';
import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/journal.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc(
      {@required JournalRepository journalRepository, @required User user,@required String date})
      : assert(journalRepository != null),
        _journalRepository = journalRepository,
        assert(user != null),
        //_user = user,
        assert(date != null),
        super(JournalState.initial(date)) ;

  final JournalRepository _journalRepository;

  @override
  Stream<JournalState> mapEventToState(
    JournalEvent event,
  ) async* {
    if (event is JournalDateChange) {
      yield JournalState.loading();
      Journal journal = await _journalRepository.journalByDate(dateformat(event.date),event.user.id);
      yield JournalState.complete(journal,dateformat(event.date));
    } else if (event is JournalUpdate) {
      yield JournalState.loading();
      Journal journal = await _journalRepository.journalByDate(event.date,event.user.id);
      yield JournalState.complete(journal,event.date);
    } else if (event is RepasClicked){
      yield JournalState.loading();
      if(event.repas == Repas.empty)
        yield JournalState.modifyRepas(Repas.empty,event.journal,event.date);
      else{
        Repas repas = await _journalRepository.repasById(event.journal.date, event.user.id, event.repas.id );
        yield JournalState.modifyRepas(repas,event.journal,event.date);
      }
    }else if (event is DayCommentsClicked){
      yield JournalState.loading();
      if(event.dayComments == DayComments.empty)
        yield JournalState.modifyDayComment(DayComments.empty,event.journal,event.date);
      else{
        DayComments dayComments = await _journalRepository.commentsById(event.journal.date, event.user.id, event.dayComments.id );
        yield JournalState.modifyDayComment(dayComments,event.journal,event.date);
      }
    }else if (event is WellBeingClicked){
      yield JournalState.loading();
      yield JournalState.modifyWellBeing(event.wellBeing,event.journal,event.date);
    }
  }

  String dateformat(DateTime date){
    
    String formattedDate = DateFormat('dd_MM_yyyy').format(date);
    return formattedDate;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
