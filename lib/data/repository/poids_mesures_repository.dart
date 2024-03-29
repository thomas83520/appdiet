import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/models/poids_mesures/poids_mesures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoidsMesuresRepository {
  PoidsMesuresRepository({required User user})
      : _firestore = FirebaseFirestore.instance,
        _user = user;

  final User _user;
  final FirebaseFirestore _firestore;

  Future<PoidsMesures> loadPoidsMesures() async {
    Map<MesureType, List<Mesures>> mesures = {};
    List<Poids> poids = [];
    Map<DateTime, List<String>> photos = {};
    List<Mesures> taille = [];
    List<Mesures> ventre = [];
    List<Mesures> hanche = [];
    List<Mesures> cuisses = [];
    List<Mesures> bras = [];
    List<Mesures> poitrine = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection("patient")
        .doc(_user.id)
        .collection("poids_mesures")
        .orderBy("date")
        .get();

    querySnapshot.docs.forEach((doc) {
      DateTime dateTime = doc["date"].toDate();

      if ((doc.data() as Map<String, dynamic>).containsKey("poids")) {
        poids.add(Poids(poids: doc["poids"], date: dateTime));
      }

      if ((doc.data() as Map<String, dynamic>).containsKey("mesures")) {
        Map<String, dynamic> map = doc["mesures"];
        map.forEach((key, value) {
          switch (key) {
            case "taille":
              taille.add(Mesures(date: dateTime, mesure: value.toDouble()));
              break;

            case "ventre":
              ventre.add(Mesures(date: dateTime, mesure: value.toDouble()));
              break;

            case "hanches":
              hanche.add(Mesures(date: dateTime, mesure: value.toDouble()));
              break;

            case "cuisses":
              cuisses.add(Mesures(date: dateTime, mesure: value.toDouble()));
              break;

            case "bras":
              bras.add(Mesures(date: dateTime, mesure: value.toDouble()));
              break;

            case "poitrine":
              poitrine.add(Mesures(date: dateTime, mesure: value.toDouble()));
              break;

            default:
              break;
          }
        });
      }

      if ((doc.data() as Map<String, dynamic>).containsKey("photos")) {
        String photo;
        List<String> urlPhoto = [];
        for (photo in doc["photos"]) {
          urlPhoto.add(photo);
        }
        photos.putIfAbsent(dateTime, () => urlPhoto);
      }
    });

    mesures.putIfAbsent(MesureType.taille, () => taille);
    mesures.putIfAbsent(MesureType.ventre, () => ventre);
    mesures.putIfAbsent(MesureType.hanche, () => hanche);
    mesures.putIfAbsent(MesureType.cuisses, () => cuisses);
    mesures.putIfAbsent(MesureType.bras, () => bras);
    mesures.putIfAbsent(MesureType.poitrine, () => poitrine);

    return PoidsMesures(mesures: mesures, poids: poids, photos: photos);
  }

  Future<void> addPoidsMesures(Map<String, dynamic> map, String url,String photoName) async {
    map.putIfAbsent("photoUrl", () => url);
    map.putIfAbsent("photoName", () => photoName);
    await _firestore
        .collection("patient")
        .doc(_user.id)
        .collection("poids_mesures")
        .add(map);
  }
}
