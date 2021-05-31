import 'dart:async';

import 'package:appdiet/data/models/goal/goals.dart';
import 'package:appdiet/data/repository/goal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc({@required GoalRepository goalRepository})
      : assert(goalRepository != null),
        _goalRepository = goalRepository,
        super(GoalState.unknown()) {
    _streamSubscription = _goalRepository.goals.listen((goals) {
      add(GoalLoaded(goals: goals));
    });
  }

  final GoalRepository _goalRepository;
  StreamSubscription _streamSubscription;
  @override
  Stream<GoalState> mapEventToState(
    GoalEvent event,
  ) async* {
    if (event is GoalLoaded) {
      yield GoalState.complete(event.goals);
    }
    if (event is GoalSelected) {
      try {
        _goalRepository.goalClicked(event.id, event.type, event.goals);
      } catch (e) {
        yield GoalState.error();
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
