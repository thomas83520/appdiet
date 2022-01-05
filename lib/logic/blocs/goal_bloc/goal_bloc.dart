import 'dart:async';

import 'package:appdiet/data/models/goal/goals.dart';
import 'package:appdiet/data/repository/goal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc({required GoalRepository goalRepository})
      : _goalRepository = goalRepository,
        super(GoalState.unknown()) {
    _streamSubscription = _goalRepository.goals.listen((goals) {
      add(GoalLoaded(goals: goals));
    });
    on<GoalEvent>((event,emit) => mapEventToState(event,emit));
  }

  final GoalRepository _goalRepository;
  late StreamSubscription _streamSubscription;

  Future<void> mapEventToState(
    GoalEvent event,Emitter<GoalState> emit
  ) async {
    if (event is GoalLoaded) {
      emit(GoalState.complete(event.goals));
    }
    if (event is GoalSelected) {
      try {
        await _goalRepository.goalClicked(event.id, event.type, event.goals);
      } catch (e) {
        emit(GoalState.error());
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
