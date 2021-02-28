part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class JournalDateChange extends JournalEvent {
  const JournalDateChange(this.date,this.user);

  final DateTime date;
  final User user;

  @override
  List<Object> get props => [date,user];
}

class JournalUpdate extends JournalEvent {
  const JournalUpdate(this.journal,this.date,this.user);
  
  final Journal journal;
  final String date;
  final User user;
  
  @override
  List<Object> get props => [journal,date,user];  
}

class RepasClicked extends JournalEvent {
  const RepasClicked({this.repas,this.journal,this.user,this.date});

  final Repas repas;
  final Journal journal;
  final User user;
  final String date;

  @override
  List<Object> get props => [repas,journal,user,date];
}

class DayCommentsClicked extends JournalEvent {
  const DayCommentsClicked({this.dayComments,this.journal,this.user,this.date});

  final DayComments dayComments;
  final Journal journal;
  final User user;
  final String date;

  @override
  List<Object> get props => [dayComments,journal,user,date];
}

class WellBeingClicked extends JournalEvent {
  const WellBeingClicked({this.wellBeing, this.journal,this.user,this.date});

  final WellBeing wellBeing;
  final Journal journal;
  final User user;
  final String date;

  @override
  List<Object> get props => [wellBeing,journal,user,date];
}