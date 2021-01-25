part of 'journal_bloc.dart';

enum JournalStateStatus {loading,fail,complete,initial,modifyRepas}

class JournalState extends Equatable {
  const JournalState._({
    this.journal = Journal.empty,
    this.date = '11_12_2020',
    this.journalStateStatus = JournalStateStatus.initial,
    this.repas = Repas.empty
  });
  
  const JournalState.fail() : this._(journalStateStatus : JournalStateStatus.fail);

  const JournalState.initial() : this._();

  const JournalState.loading() : this._(journalStateStatus : JournalStateStatus.loading);

  const JournalState.complete(Journal journal) : this._(journalStateStatus: JournalStateStatus.complete,journal : journal);

  const JournalState.modifyRepas(Repas repas,Journal journal) : this._(journalStateStatus : JournalStateStatus.modifyRepas, repas : repas,journal : journal);

  final JournalStateStatus journalStateStatus;
  final Journal journal;
  final String date;
  final Repas repas;
  
  @override
  List<Object> get props => [journal, journalStateStatus, date,repas];
}
