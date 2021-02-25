import 'package:appdiet/data/models/wellbeing.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detailwellbeing_state.dart';

class DetailwellbeingCubit extends Cubit<DetailwellBeingState> {
  DetailwellbeingCubit(
      {@required JournalRepository journalRepository,
      @required WellBeing wellBeing,
      @required User user,
      @required String date})
      : assert(journalRepository != null),
        _journalRepository = journalRepository,
        assert(user != User.empty),
        _user = user,
        assert(date != null),
        _date = date,
        super(DetailwellBeingState(wellBeing: wellBeing));

  final String _date;
  final User _user;
  final JournalRepository _journalRepository;

  void stressChanged(double value) {
    print(value.toString());
    emit(state.copyWith(stress: value.toInt()));
  }

  void ballonnementsChanged(double value) {
    print(value.toString());
    emit(state.copyWith(ballonnements: value.toInt()));
  }

  void hydratationChanged(double value) {
    print(value.toString());
    emit(state.copyWith(hydratation: value.toInt()));
  }

  void transitChanged(double value) {
    print(value.toString());
    emit(state.copyWith(transit: value.toInt()));
  }

  void fatigueChanged(double value) {
    print(value.toString());
    emit(state.copyWith(fatigue: value.toInt()));
  }

  void sommeilChanged(double value) {
    print(value.toString());
    emit(state.copyWith(sommeil: value.toInt()));
  }

  void humeurChanged(double value) {
    print(value.toString());
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
