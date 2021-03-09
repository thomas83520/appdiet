part of 'goal_bloc.dart';

enum GoalStateStatus {
  loading,
  unknown,
  error,
  complete,
}

class GoalState extends Equatable {
  const GoalState._({this.goals =  Goals.empty,this.status = GoalStateStatus.unknown});

  final Goals goals;
  final GoalStateStatus status;


  const GoalState.loading() : this._(status : GoalStateStatus.loading);
  const GoalState.complete(Goals goals) : this._(status : GoalStateStatus.complete, goals: goals);
  const GoalState.error() : this._(status : GoalStateStatus.error);
  const GoalState.unknown() : this._(status : GoalStateStatus.unknown);

  @override
  List<Object> get props => [goals,status];
}
