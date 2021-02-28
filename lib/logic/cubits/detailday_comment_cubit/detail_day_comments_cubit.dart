import 'dart:async';
import 'package:appdiet/data/models/Day_comments.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'detail_day_comments_state.dart';

class DetailDayCommentsCubit extends Cubit<DetailDayCommentsState> {
  DetailDayCommentsCubit(
      {@required JournalRepository journalRepository,
      @required DayComments dayComments,
      @required User user,
      @required String date})
      : assert(journalRepository != null),
        _journalRepository = journalRepository,
        assert(user != User.empty),
        _user = user,
        assert(date != null),
        _date = date,
        super(DetailDayCommentsState(dayComments: dayComments));

  final String _date;
  final User _user;
  final JournalRepository _journalRepository;


  void nameChanged(String name){
    emit(state.copyWith(nameRepas: name));
  }

  void timeChanged(int heure,int minutes){
    emit(state.copyWith(heure: heure.toString()+":"+_formatMinute(minutes)));
  }

  void contenuChanged(String value){
    emit(state.copyWith(contenu: value));
  }

  Future<void> validateDayComments() async{
    emit(state.copyWith(status: SubmissionStatus.loading));
    try{
      await _journalRepository.validateDayComments(state.dayComments,_user,_date);
      emit(state.copyWith(status: SubmissionStatus.success));
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