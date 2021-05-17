import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Day comment', () {
    test('Day comment instance', () {
      expect(
          DayComments(
            id: "id",
            titre: "titre",
            heure: "heure",
            contenu: "contenu",
          ),
          DayComments(
            id: "id",
            titre: "titre",
            heure: "heure",
            contenu: "contenu",
          ));
    });

    test('Day Comment empty', () {
      expect(
          DayComments.empty,
          DayComments(
            id: "",
            titre: "",
            heure: "",
            contenu: "",
          ));
    });

    test('Day comment from snapshot', () {
      List<dynamic> snapshot = [
        {
          "id": "id",
          "titre": "titre",
          "heure": "heure",
        }
      ];
      expect(DayComments.fromSnapshot(snapshot), [
        DayComments(
          id: "id",
          titre: "titre",
          heure: "heure",
          contenu: "",
        ),
      ]);
    });

    test('Day comment toDocument', () {
      expect(
          DayComments(
            id: "id",
            titre: "titre",
            heure: "heure",
            contenu: "contenu",
          ).toDocuments(),
          {
            "id": "id",
            "titre": "titre",
            "heure": "heure",
            "contenu": "contenu"
          });
    });
  });
}
