import 'dart:async';
import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detail_day_comments_state.dart';

class DetailDayCommentsCubit extends Cubit<DetailDayCommentsState> {
  DetailDayCommentsCubit(
      {required JournalRepository journalRepository,
      required DayComments dayComments,
      required User user,
      required DateTime date})
      : 
        _journalRepository = journalRepository,
        _user = user,
        _date = date,
        super(DetailDayCommentsState(dayComments: dayComments));

  final DateTime _date;
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