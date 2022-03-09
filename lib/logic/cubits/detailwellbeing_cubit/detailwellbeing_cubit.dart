import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detailwellbeing_state.dart';

class DetailwellbeingCubit extends Cubit<DetailwellBeingState> {
  DetailwellbeingCubit(
      {required JournalRepository journalRepository,
      required WellBeing wellBeing,
      required User user,
      required DateTime date}):
        _journalRepository = journalRepository,
        assert(user != User.empty),
        _user = user,
        _date = date,
        super(DetailwellBeingState(wellBeing: wellBeing));

  final DateTime _date;
  final User _user;
  final JournalRepository _journalRepository;

  void stressChanged(double value) {
    emit(state.copyWith(stress: value.toInt()));
  }

  void ballonnementsChanged(double value) {
    emit(state.copyWith(ballonnements: value.toInt()));
  }

  void hydratationChanged(double value) {
    emit(state.copyWith(hydratation: value.toInt()));
  }

  void transitChanged(double value) {
    emit(state.copyWith(transit: value.toInt()));
  }

  void fatigueChanged(double value) {
    emit(state.copyWith(fatigue: value.toInt()));
  }

  void sommeilChanged(double value) {
    emit(state.copyWith(sommeil: value.toInt()));
  }

  void humeurChanged(double value) {
    emit(state.copyWith(humeur: value.toInt()));
  }

  Future<void> validateWellbeing() async {
    emit(state.copyWith(status: SubmissionStatus.loading));
    try {
      await _journalRepository.validateWellbeing(state.wellBeing,_user,_date);
      emit(state.copyWith(status: SubmissionStatus.success));
    } on Exception {
      emit(state.copyWith(status: SubmissionStatus.failure));
    }
  }
}
