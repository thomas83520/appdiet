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
    this.date = '11_12_2020',
    this.journalStateStatus = JournalStateStatus.initial,
    this.repas = Repas.empty,
    this.dayComments = DayComments.empty,
    this.wellBeing = WellBeing.empty,
  });

  const JournalState.fail()
      : this._(journalStateStatus: JournalStateStatus.fail);

  const JournalState.initial() : this._();

  const JournalState.loading()
      : this._(journalStateStatus: JournalStateStatus.loading);

  const JournalState.complete(Journal journal)
      : this._(
            journalStateStatus: JournalStateStatus.complete, journal: journal);

  const JournalState.modifyRepas(Repas repas, Journal journal)
      : this._(
          journalStateStatus: JournalStateStatus.modifyRepas,
          repas: repas,
          journal: journal,
        );

  const JournalState.modifyDayComment(DayComments dayComments, Journal journal)
      : this._(
          journalStateStatus: JournalStateStatus.modifyDayComment,
          dayComments: dayComments,
          journal: journal,
        );

  const JournalState.modifyWellBeing(WellBeing wellBeing, Journal journal)
      : this._(
          journalStateStatus: JournalStateStatus.modifyWellBeing,
          wellBeing: wellBeing,
          journal: journal,
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
