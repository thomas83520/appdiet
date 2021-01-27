import 'package:equatable/equatable.dart';

class WellBeing extends Equatable {
  final String id;
  final int stress;
  final int ballonnements;
  final int hydratation;
  final int transit;
  final int fatigue;
  final int humeur;

  const WellBeing(
      {this.id,
      this.stress,
      this.ballonnements,
      this.hydratation,
      this.transit,
      this.fatigue,
      this.humeur});

  static WellBeing fromSnapshot(Map<String, dynamic> snapshot) {
    print("id "+  snapshot["id"].toString());
    return WellBeing(
      id: snapshot["id"].toString(),
      stress: snapshot["stress"],
      ballonnements: snapshot["ballonnements"],
      hydratation: snapshot["hydratation"],
      transit: snapshot["transit"],
      fatigue: snapshot["fatigue"],
      humeur: snapshot["humeur"],
    );
  }

  Map<String, Object> toDocuments() {
    return {
      "id": id,
      "stress": stress,
      "ballonnements": ballonnements,
      "hydratation": hydratation,
      "transit": transit,
      "fatigue": fatigue,
      "humeur": humeur,
    };
  }

  static const empty = WellBeing(
    id: "",
    stress: 5,
    ballonnements: 5,
    hydratation: 5,
    transit: 5,
    fatigue: 5,
    humeur: 5,
  );

  @override
  List<Object> get props =>
      [id, stress, ballonnements, hydratation, transit, fatigue, humeur];
}
