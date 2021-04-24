part of 'plan_alimentaire_cubit.dart';

abstract class PlanAlimentaireState extends Equatable {
  const PlanAlimentaireState();

  @override
  List<Object> get props => [];
}

class PlanAlimentaireInitial extends PlanAlimentaireState {}

class PlanAlimentaireLoadInProgress extends PlanAlimentaireState {}

class PlanAlimentaireLoadFailure extends PlanAlimentaireState{}

class PlanAlimentaireLoadSuccess extends PlanAlimentaireState {

  const PlanAlimentaireLoadSuccess({@required this.document}): assert (document !=null);

  final PDFDocument document;

  @override
  List<Object>  get props => [document];
}