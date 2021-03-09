part of 'goal_bloc.dart';

enum GoalType{
  shortTerm,
  longTerm,
}

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}


class GoalLoaded extends GoalEvent{
  const GoalLoaded({this.goals});

  final Goals goals;

  @override
  List<Object> get props => [goals];
}

class GoalSelected extends GoalEvent{
  const GoalSelected({this.id,this.type,this.goals});

  final int id;
  final GoalType type;
  final Goals goals;
  @override
  List<Object> get props => [id,type,goals];
}