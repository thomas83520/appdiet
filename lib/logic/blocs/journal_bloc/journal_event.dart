part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class JournalDateChanges extends JournalEvent {
  const JournalDateChanges(this.date);

  final String date;

  @override
  List<Object> get props => [date];
}

class JournalUpdate extends JournalEvent {
  const JournalUpdate(this.journal);
  
  final Journal journal;
  
  @override
  List<Object> get props => [journal];  
}

class RepasClicked extends JournalEvent {
  const RepasClicked({this.repas,this.journal,this.user});

  final Repas repas;
  final Journal journal;
  final User user;

  @override
  List<Object> get props => [repas,journal,user];
}