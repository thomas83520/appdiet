import 'dart:async';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/tools/stringformatter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
part 'detailmeal_state.dart';

class DetailmealCubit extends Cubit<DetailmealState> {
  DetailmealCubit(
      {required JournalRepository journalRepository,
      required Repas repas,
      required User user,
      required DateTime date})
      : _journalRepository = journalRepository,
        assert(user != User.empty),
        _user = user,
        _date = date,
        super(DetailmealState(repas: repas, file: XFile('')));

  final DateTime _date;
  final User _user;
  final JournalRepository _journalRepository;

  Future<void> loadData() async {
    if (state.repas == Repas.empty) {
      int heure = int.parse(DateFormat('HH').format(DateTime.now()));
      int minutes = int.parse(DateFormat('mm').format(DateTime.now()));
      emit(state.copyWith(
          nameRepas: 'Petit déjeuner',
          heure: heure.toString() + ":" + _formatMinute(minutes)));
    } else {
      if (state.repas.photoName != '') {
        String url =
            await _journalRepository.getPhotoUrl(_user, state.repas.photoName);
        emit(state.copyWith(photoUrl: url));
      }
    }
  }

  void nameChanged(String name) {
    if (state.file.path == '')
      emit(state.copyWith(nameRepas: name));
    else
      emit(state.copyWith(nameRepas: name, photoName: fileName(state.repas)));
  }

  void timeChanged(int heure, int minutes) {
    if (state.file.path == '')
      emit(state.copyWith(
          heure: heure.toString() + ":" + _formatMinute(minutes)));
    else
      emit(state.copyWith(
          heure: heure.toString() + ":" + _formatMinute(minutes),
          photoName: fileName(state.repas)));
  }

  void contenuChanged(String value) {
    emit(state.copyWith(contenu: value));
  }

  void beforeChanged(double value) {
    emit(state.copyWith(before: value.toInt()));
  }

  void satieteChanged(double value) {
    emit(state.copyWith(satiete: value.toInt()));
  }

  void commentaireChanged(String value) {
    emit(state.copyWith(commentaire: value));
  }

  void fileChanged(XFile file) {
    emit(state.copyWith(file: file, photoName: fileName(state.repas)));
  }

  Future<void> validateRepas() async {
    emit(state.copyWith(status: SubmissionStatus.loading));
    try {
      if (state.file.path != '')
        await _journalRepository.uploadPhoto(
            _user, state.file.path, state.repas.photoName);
      await _journalRepository.validateRepas(state.repas, _user, _date);
      emit(state.copyWith(status: SubmissionStatus.success));
    } on Exception {
      emit(state.copyWith(status: SubmissionStatus.failure));
    }
  }

  String fileName(Repas repas) {
    String name = StringFormatter.removeDiacritics(
        (repas.name + '-' + repas.heure + '-' + DateFormat('d_M_y').format(_date))).replaceAll(new RegExp(r'[^\w]+'), '_');
    return name;
  }

  String _formatMinute(int minute) {
    if (minute < 10) {
      return "0" + minute.toString();
    } else
      return minute.toString();
  }
}
