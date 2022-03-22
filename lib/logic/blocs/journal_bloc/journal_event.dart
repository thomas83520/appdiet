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
  final DateTime date;
  final User user;
  
  @override
  List<Object> get props => [journal,date,user];  
}

class RepasClicked extends JournalEvent {
  const RepasClicked({required this.repas,required this.journal,required this.user,required this.date});

  final Repas repas;
  final Journal journal;
  final User user;
  final DateTime date;

  @override
  List<Object> get props => [repas,journal,user,date];
}

class DayCommentsClicked extends JournalEvent {
  const DayCommentsClicked({required this.dayComments,required this.journal,required this.user,required this.date});

  final DayComments dayComments;
  final Journal journal;
  final User user;
  final DateTime date;

  @override
  List<Object> get props => [dayComments,journal,user,date];
}

class WellBeingClicked extends JournalEvent {
  const WellBeingClicked({required this.wellBeing, required this.journal,required this.user,required this.date});

  final WellBeing wellBeing;
  final Journal journal;
  final User user;
  final DateTime date;

  @override
  List<Object> get props => [wellBeing,journal,user,date];
}