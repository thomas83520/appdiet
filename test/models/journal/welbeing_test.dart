import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('WellBeing', () {
    test('WellBeing instance', () {
      expect(
          WellBeing(
              stress: 1,
              ballonnements: 1,
              hydratation: 1,
              transit: 1,
              fatigue: 1,
              sommeil: 1,
              humeur: 1),
          WellBeing(
              stress: 1,
              ballonnements: 1,
              hydratation: 1,
              transit: 1,
              fatigue: 1,
              sommeil: 1,
              humeur: 1));
    });

    test('WellBeing empty', () {
      expect(
          WellBeing.empty,
          WellBeing(
              stress: 5,
              ballonnements: 5,
              hydratation: 5,
              transit: 5,
              fatigue: 5,
              sommeil: 5,
              humeur: 5));
    });

    test('WellBeing from snapshot', () {
      Map<String, dynamic> snapshot = {
        "stress": 1,
        "ballonnements": 1,
        "hydratation": 1,
        "transit": 1,
        "fatigue": 1,
        "sommeil": 1,
        "humeur": 1
      };
      expect(
          WellBeing.fromSnapshot(snapshot),
          WellBeing(
              stress: 1,
              ballonnements: 1,
              hydratation: 1,
              transit: 1,
              fatigue: 1,
              sommeil: 1,
              humeur: 1));
    });

    test('WellBeing toDocument', () {
      expect(
          WellBeing(
                  stress: 1,
                  ballonnements: 1,
                  hydratation: 1,
                  transit: 1,
                  fatigue: 1,
                  sommeil: 1,
                  humeur: 1)
              .toDocuments(),
          {
            "stress": 1,
            "ballonnements": 1,
            "hydratation": 1,
            "transit": 1,
            "fatigue": 1,
            "sommeil": 1,
            "humeur": 1
          });
    });
  });
}
