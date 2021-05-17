import 'package:appdiet/data/models/journal/repas.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Repas', () {
    test('Repas instance', () {
      expect(
          Repas(
              id: "id",
              name: "name",
              heure: "heure",
              before: 1,
              satiete: 1,
              contenu: "contenu",
              commentaire: "commentaire"),
          Repas(
              id: "id",
              name: "name",
              heure: "heure",
              before: 1,
              satiete: 1,
              contenu: "contenu",
              commentaire: "commentaire"));
    });

    test('Repas empty', () {
      expect(
          Repas.empty,
          Repas(
              id: "",
              name: "",
              heure: "",
              before: 5,
              satiete: 5,
              contenu: "",
              commentaire: ""));
    });

    test('Repas from snapshot (doit fail snapshot return list repas)', () {
      List<dynamic> snapshot = [
        {
          "id": "id",
          "nom": "name",
          "heure": "heure",
          "contenu": "contenu",
        }
      ];
      expect(
          Repas.fromSnapshot(snapshot),
          [Repas(
              id: "id",
              name: "name",
              heure: "heure",
              before: 0,
              satiete: 0,
              contenu: "contenu",
              commentaire: "")]);
    });

    test('Repas toDocument', () {
      expect(
          Repas(
            id: "id",
            name: "name",
            heure: "heure",
            before: 1,
            satiete: 1,
            contenu: "contenu",
            commentaire: "commentaire",
          ).toDocuments(),
          {
            "id": "id",
            "name": "name",
            "heure": "heure",
            "before": 1,
            "satiete": 1,
            "contenu": "contenu",
            "commentaire": "commentaire"
          });
    });
  });
}
