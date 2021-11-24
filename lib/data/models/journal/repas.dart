import 'package:equatable/equatable.dart';

class Repas extends Equatable {
  const Repas(
      {required this.id,
      required this.name,
      required this.heure,
      required this.before,
      required this.satiete,
      required this.contenu,
      required this.commentaire,
      required this.photoName});

  final String id;
  final String name;
  final String heure;
  final int before;
  final int satiete;
  final String contenu;
  final String commentaire;
  final String photoName;

  static const empty = Repas(
      id: '',
      name: '',
      heure: '',
      before: 5,
      satiete: 5,
      contenu: '',
      commentaire: '',
      photoName: '');

  static List<Repas> fromSnapshot(List<dynamic> snapshot) {
    return snapshot
        .map((snap) => Repas(
              id: snap["id"],
              name: snap["nom"],
              heure: snap["heure"],
              before: 0,
              satiete: 0,
              contenu: (snap as Map<String,dynamic>).containsKey("contenu") ? snap["contenu"] : "",
              commentaire: "",
              photoName: '',
            ))
        .toList();
  }

  Map<String, Object> toDocuments() {
    return {
      "id": id,
      "name": name,
      "heure": heure,
      "before": before,
      "satiete": satiete,
      "contenu": contenu,
      "commentaire": commentaire,
      "photoName" : photoName,
    };
  }

  @override
  List<Object> get props =>
      [id, name, heure, before, satiete, contenu, commentaire,photoName];
}
