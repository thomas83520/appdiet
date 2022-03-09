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
    required this.journal,
    required this.date,
    this.journalStateStatus = JournalStateStatus.initial,
    this.repas = Repas.empty,
    this.dayComments = DayComments.empty,
    this.wellBeing = WellBeing.empty,
  });

  const JournalState.fail(DateTime date,Journal journal)
      : this._(journalStateStatus: JournalStateStatus.fail,date : date,journal : journal);

  const JournalState.initial(DateTime date,Journal journal) : this._(date : date,journal : journal);

  const JournalState.loading(DateTime date, Journal journal)
      : this._(journalStateStatus: JournalStateStatus.loading,date : date,journal : journal);

  const JournalState.complete(Journal journal,DateTime date)
      : this._(
            journalStateStatus: JournalStateStatus.complete, journal: journal,date: date);

  const JournalState.modifyRepas(Repas repas, Journal journal,DateTime date)
      : this._(
          journalStateStatus: JournalStateStatus.modifyRepas,
          repas: repas,
          journal: journal,
          date : date
        );

  const JournalState.modifyDayComment(DayComments dayComments, Journal journal,DateTime date)
      : this._(
          journalStateStatus: JournalStateStatus.modifyDayComment,
          dayComments: dayComments,
          journal: journal,
          date: date,
        );

  const JournalState.modifyWellBeing(WellBeing wellBeing, Journal journal,DateTime date)
      : this._(
          journalStateStatus: JournalStateStatus.modifyWellBeing,
          wellBeing: wellBeing,
          journal: journal,
          date : date,
        );

  final WellBeing wellBeing;
  final JournalStateStatus journalStateStatus;
  final Journal journal;
  final DateTime date;
  final Repas repas;
  final DayComments dayComments;

  @override
  List<Object> get props => [journal, journalStateStatus, date, repas];
}
