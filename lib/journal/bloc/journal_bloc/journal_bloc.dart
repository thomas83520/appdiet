import 'dart:async';

import 'package:appdiet/journal/repository/journal_repository.dart';
import 'package:appdiet/journal/repository/models/journal.dart';
import 'package:appdiet/journal/repository/models/repas.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        super(JournalState.initial()) {
    _journalSubscription = _journalRepository
        .journalByDate(date, user.id)
        .listen((journal) {
      add(JournalUpdate(journal));
    });
  }

  final JournalRepository _journalRepository;
  StreamSubscription<Journal> _journalSubscription;

  @override
  Stream<JournalState> mapEventToState(
    JournalEvent event,
  ) async* {
    if (event is JournalDateChanges) {
    } else if (event is JournalUpdate) {
      yield JournalState.complete(event.journal);
    } else if (event is RepasClicked){
      yield JournalState.loading();
      if(event.repas == Repas.empty)
        yield JournalState.modifyRepas(Repas.empty,event.journal);
      else{
        Repas repas = await _journalRepository.repasById(event.journal.date, event.user.id, event.repas.id );
        yield JournalState.modifyRepas(repas,event.journal);
      }
    }
  }


  @override
  Future<void> close() {
    _journalSubscription?.cancel();
    return super.close();
  }
}