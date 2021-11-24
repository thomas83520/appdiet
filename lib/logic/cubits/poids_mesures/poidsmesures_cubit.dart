import 'package:appdiet/data/models/poids_mesures/poids_mesures.dart';
import 'package:appdiet/data/repository/poids_mesures_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'poidsmesures_state.dart';

class PoidsMesuresCubit extends Cubit<PoidsMesuresState> {
  PoidsMesuresCubit({required PoidsMesuresRepository poidsMesuresRepository})
      : _poidsMesuresRepository = poidsMesuresRepository,
        super(PoidsMesuresInitial());

  final PoidsMesuresRepository _poidsMesuresRepository;

  Future<void> loadPoidsMesures() async {
    emit(PoidsMesuresLoadInProgress());
    try {
      PoidsMesures poidsMesures =
          await _poidsMesuresRepository.loadPoidsMesures();
      emit(PoidsMesuresLoadSuccess(poidsMesures: poidsMesures));
    } catch (e) {
      emit(PoidsMesuresLoadFailure());
    }
  }
}
