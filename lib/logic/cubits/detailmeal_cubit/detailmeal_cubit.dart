import 'dart:async';
import 'package:appdiet/data/models/repas.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'detailmeal_state.dart';

class DetailmealCubit extends Cubit<DetailmealState> {
  DetailmealCubit(
      {@required JournalRepository journalRepository,
      @required Repas repas,
      @required User user,
      @required String date})
      : assert(journalRepository != null),
        _journalRepository = journalRepository,
        assert(user != User.empty),
        _user = user,
        assert(date != null),
        _date = date,
        super(DetailmealState(repas: repas));

  final String _date;
  final User _user;
  final JournalRepository _journalRepository;


  void nameChanged(String name){
    print("state : " + state.repas.toString());
    emit(state.copyWith(nameRepas: name));
  }

  void timeChanged(int heure,int minutes){
    emit(state.copyWith(heure: heure.toString()+":"+_formatMinute(minutes)));
  }

  void contenuChanged(String value){
    print("value : " +value);
    emit(state.copyWith(contenu: value));
  }

  void beforeChanged(double value){
    print(value.toString());
    emit(state.copyWith(before: value.toInt()));
  }

  void satieteChanged(double value){
    print(value.toString());
    emit(state.copyWith(satiete: value.toInt()));
  }

  void commentaireChanged(String value){
    print("value : " +value);
    emit(state.copyWith(commentaire: value));
  }

  Future<void> validateRepas() async{
    emit(state.copyWith(status: SubmissionStatus.loading));
    try{
      await _journalRepository.validateRepas(state.repas,_user,_date);
      emit(state.copyWith(status: SubmissionStatus.success));
      print("emited");
    }
    on Exception{
      emit(state.copyWith(status: SubmissionStatus.failure));
    }
  }


  String _formatMinute(int minute){
    if(minute < 10){
      return "0"+minute.toString();
    }
    else return minute.toString();
  }
}
