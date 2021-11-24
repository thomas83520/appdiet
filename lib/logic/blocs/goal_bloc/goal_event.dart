part of 'goal_bloc.dart';


abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}


class GoalLoaded extends GoalEvent{
  const GoalLoaded({required this.goals});

  final Goals goals;

  @override
  List<Object> get props => [goals];
}

class GoalSelected extends GoalEvent{
  const GoalSelected({required this.id,required this.type,required this.goals});

  final int id;
  final GoalType type;
  final Goals goals;
  @override
  List<Object> get props => [id,type,goals];
}