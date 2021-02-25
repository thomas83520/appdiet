import 'package:equatable/equatable.dart';

class WellBeing extends Equatable {
  final int stress;
  final int ballonnements;
  final int hydratation;
  final int transit;
  final int fatigue;
  final int sommeil;
  final int humeur;
  

  const WellBeing(
      {
      this.stress,
      this.ballonnements,
      this.hydratation,
      this.transit,
      this.fatigue,
      this.sommeil,
      this.humeur});

  static WellBeing fromSnapshot(Map<String, dynamic> snapshot) {
    return WellBeing(
      stress: snapshot["stress"],
      ballonnements: snapshot["ballonnements"],
      hydratation: snapshot["hydratation"],
      transit: snapshot["transit"],
      fatigue: snapshot["fatigue"],
      sommeil: snapshot["sommeil"],
      humeur: snapshot["humeur"],
    );
  }

  Map<String, Object> toDocuments() {
    return {
      "stress": stress,
      "ballonnements": ballonnements,
      "hydratation": hydratation,
      "transit": transit,
      "fatigue": fatigue,
      "sommeil" : sommeil,
      "humeur": humeur,
    };
  }

  static const empty = WellBeing(
    stress: 5,
    ballonnements: 5,
    hydratation: 5,
    transit: 5,
    fatigue: 5,
    sommeil: 5,
    humeur: 5,
  );

  @override
  List<Object> get props =>
      [ stress, ballonnements, hydratation, transit, fatigue,sommeil, humeur];
}
