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
      required this.photoName,
      required this.photoUrl});

  final String id;
  final String name;
  final String heure;
  final int before;
  final int satiete;
  final String contenu;
  final String commentaire;
  final String photoName;
  final String photoUrl;

  static const empty = Repas(
      id: '',
      name: '',
      heure: '',
      before: 5,
      satiete: 5,
      contenu: '',
      commentaire: '',
      photoName: '',
      photoUrl: '');

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
              photoUrl: '',
            ))
        .toList();
  }

  Map<String, Object> toDocuments(String newphotoUrl) {
    return {
      "id": id,
      "name": name,
      "heure": heure,
      "before": before,
      "satiete": satiete,
      "contenu": contenu,
      "commentaire": commentaire,
      "photoName" : photoName,
      "photoUrl" : newphotoUrl
    };
  }

  @override
  List<Object> get props =>
      [id, name, heure, before, satiete, contenu, commentaire,photoName,photoUrl];
}
