part of 'journal_bloc.dart';

enum JournalStateStatus {
  loading,
  fail,
  complete,
  initial,
  modifyRepas,
  modifyDayComment,
  modifyWellBeing
}

class JournalState extends Equatable {
  const JournalState._({
    this.journal = Journal.empty,
    this.date = 'test',
    this.journalStateStatus = JournalStateStatus.initial,
    this.repas = Repas.empty,
    this.dayComments = DayComments.empty,
    this.wellBeing = WellBeing.empty,
  });

  const JournalState.fail()
      : this._(journalStateStatus: JournalStateStatus.fail);

  const JournalState.initial(String date) : this._(date : date);

  const JournalState.loading()
      : this._(journalStateStatus: JournalStateStatus.loading);

  const JournalState.complete(Journal journal,String date)
      : this._(
            journalStateStatus: JournalStateStatus.complete, journal: journal,date: date);

  const JournalState.modifyRepas(Repas repas, Journal journal,String date)
      : this._(
          journalStateStatus: JournalStateStatus.modifyRepas,
          repas: repas,
          journal: journal,
          date : date
        );

  const JournalState.modifyDayComment(DayComments dayComments, Journal journal,String date)
      : this._(
          journalStateStatus: JournalStateStatus.modifyDayComment,
          dayComments: dayComments,
          journal: journal,
          date: date,
        );

  const JournalState.modifyWellBeing(WellBeing wellBeing, Journal journal,String date)
      : this._(
          journalStateStatus: JournalStateStatus.modifyWellBeing,
          wellBeing: wellBeing,
          journal: journal,
          date : date,
        );

  final WellBeing wellBeing;
  final JournalStateStatus journalStateStatus;
  final Journal journal;
  final String date;
  final Repas repas;
  final DayComments dayComments;

  @override
  List<Object> get props => [journal, journalStateStatus, date, repas];
}
