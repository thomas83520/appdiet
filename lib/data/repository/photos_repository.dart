import 'dart:io';

import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PhotosRepository {
  PhotosRepository({User user})
      : assert(user != null),
        _user = user;

  final User _user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> loadPhotos() async {
    List<String> photosUrl = [];
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref(_user.id + "/photos")
        .listAll();

    for (var item in result.items) {
      photosUrl.add(await item.getDownloadURL());
    }

    print(photosUrl);

    return photosUrl;
  }

  Future<DetailPhoto> loadDetail(String url) async {
    double poids;
    Map<String, double> mesures;
    DateTime date;

    QuerySnapshot doc = await firestore
        .collection("patient")
        .doc(_user.id)
        .collection("poids_mesures")
        .where("photoUrl", isEqualTo: url)
        .limit(1)
        .get();

    doc.docs.forEach((doc) {
      date = doc["date"].toDate();

      if (doc.data().containsKey("poids")) {
        poids = doc["poids"];
      }

      if (doc.data().containsKey("mesures")) {
        Map<String, dynamic> map = doc["mesures"];
        map.forEach((key, value) {
          switch (key) {
            case "taille":
              mesures.putIfAbsent("taille", () => value.toDouble());
              break;

            case "ventre":
              mesures.putIfAbsent("ventre", () => value.toDouble());
              break;

            case "hanche":
              mesures.putIfAbsent("hanche", () => value.toDouble());
              break;

            case "cuisses":
              mesures.putIfAbsent("cuisses", () => value.toDouble());
              break;

            case "bras":
              mesures.putIfAbsent("bras", () => value.toDouble());
              break;

            case "poitrine":
              mesures.putIfAbsent("poitrine", () => value.toDouble());
              break;

            default:
              break;
          }
        });
      }
    });

    return DetailPhoto(
        photoUrl: url, poids: poids, mesures: mesures, date: date);
  }

  Future<void> uploadPhoto(String filePath,String fileName) async {
    File file = File(filePath);
    print(fileName);
    await firebase_storage.FirebaseStorage.instance
        .ref(_user.id+'/photos/'+fileName+'.png')
        .putFile(file);
  }
}
