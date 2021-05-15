part of 'poidsmesures_cubit.dart';

abstract class PoidsMesuresState extends Equatable {
  const PoidsMesuresState();

  @override
  List<Object> get props => [];
}

class PoidsMesuresInitial extends PoidsMesuresState {}

class PoidsMesuresLoadInProgress extends PoidsMesuresState{}

class PoidsMesuresLoadSuccess extends PoidsMesuresState{
  const PoidsMesuresLoadSuccess({@required this.poidsMesures}) : assert (poidsMesures != null);

  final PoidsMesures poidsMesures;

  @override
  List<Object> get props => [poidsMesures];
}

class PoidsMesuresLoadFailure extends PoidsMesuresState{}