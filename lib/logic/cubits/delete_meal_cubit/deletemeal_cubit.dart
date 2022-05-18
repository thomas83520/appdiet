import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/user.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'deletemeal_state.dart';

class DeletemealCubit extends Cubit<DeletemealState> {
  DeletemealCubit({required this.journalRepository, required this.user})
      : super(DeletemealInitial());

  final JournalRepository journalRepository;
  final User user;
  Future<void> deleteMeal(String id, DateTime date) async {
    emit(DeletemealLoading());

    try {
      await journalRepository.deleteMeal(user, id, date);
      emit(DeletemealSucces());
    } catch (e) {
      print("error");
      emit(DeletemealFailure());
    }
  }
}
