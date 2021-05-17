import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  DateTime date = DateTime.now();
  group('Photos detail', () {
    test('Photo Detail', () {
      Map<String, double> mesures = {"bras": 12.0, "jambes": 23.0};
      expect(
          DetailPhoto(
              date: date,
              poids: 12.0,
              photoUrl: "photoUrl",
              mesures: mesures),
          DetailPhoto(
              date: date,
              poids: 12.0,
              photoUrl: "photoUrl",
              mesures: mesures));
    });
  });
}
