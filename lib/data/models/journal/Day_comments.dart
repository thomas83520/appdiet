import 'package:equatable/equatable.dart';

class DayComments extends Equatable {
  const DayComments(
      {required this.id,
      required this.titre,
      required this.heure,
      required this.contenu});

  final String id;
  final String titre;
  final String heure;
  final String contenu;

  static const empty = DayComments(id: '', titre: '', heure: '', contenu: '');

  static List<DayComments> fromSnapshot(List<dynamic> snapshot) {
    return snapshot
        .map((snap) => DayComments(
              id: snap["id"],
              titre: snap["titre"],
              heure: snap["heure"],
              contenu: "",
            ))
        .toList();
  }

  Map<String, Object> toDocuments() {
    return {
      "id": id,
      "titre": titre,
      "heure": heure,
      "contenu": contenu,
    };
  }

  @override
  List<Object> get props => [id, titre, heure, contenu];
}
