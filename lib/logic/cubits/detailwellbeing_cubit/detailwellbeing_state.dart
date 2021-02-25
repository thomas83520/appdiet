part of 'detailwellbeing_cubit.dart';

enum SubmissionStatus { loading, success, failure, dirty }

class DetailwellBeingState extends Equatable {
  const DetailwellBeingState(
      {this.wellBeing, this.status = SubmissionStatus.dirty});

  final WellBeing wellBeing;
  final SubmissionStatus status;

  @override
  List<Object> get props => [wellBeing, status];

  DetailwellBeingState copyWith(
      {final int stress,
      final int ballonnements,
      final int hydratation,
      final int transit,
      final int fatigue,
      final int sommeil,
      final int humeur,
      SubmissionStatus status}) {
    return DetailwellBeingState(
        wellBeing: WellBeing(
          stress: stress ?? this.wellBeing.stress,
          ballonnements: ballonnements ?? this.wellBeing.ballonnements,
          hydratation: hydratation ?? this.wellBeing.hydratation,
          transit: transit ?? this.wellBeing.transit,
          fatigue: fatigue ?? this.wellBeing.fatigue,
          sommeil: sommeil ?? this.wellBeing.sommeil,
          humeur: humeur ?? this.wellBeing.humeur,
        ),
        status: status ?? this.status);
  }
}
