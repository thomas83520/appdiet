import 'dart:io';

import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PhotosRepository {
  PhotosRepository({required User user}) : _user = user;

  final User _user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<DetailPhoto>> loadPhotos() async {
    List<DetailPhoto> photosUrl = [];
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref(_user.id + "/photos")
        .listAll();

    for (var item in result.items) {
      photosUrl.add(DetailPhoto(photoUrl: await item.getDownloadURL(), date: DateTime.now(),mesures: {},poids: 0,photoName: item.name));
    }

    return photosUrl;
  }

  Future<DetailPhoto> loadDetail(String url) async {
    double poids = 0;
    Map<String, double> mesures = {};
    DateTime date = DateTime.now();
    String photoName="";

    QuerySnapshot doc = await firestore
        .collection("patient")
        .doc(_user.id)
        .collection("poids_mesures")
        .where("photoUrl", isEqualTo: url)
        .limit(1)
        .get();

    doc.docs.forEach((doc) {
      date = doc["date"].toDate();

      photoName = doc["photoName"];

      if ((doc.data() as Map<String, dynamic>).containsKey("poids")) {
        poids = doc["poids"];
      }

      if ((doc.data() as Map<String, dynamic>).containsKey("mesures")) {
        Map<String, dynamic> map = doc["mesures"];
        map.forEach((key, value) {
          switch (key) {
            case "taille":
              mesures.putIfAbsent("taille", () => value.toDouble());
              break;

            case "ventre":
              mesures.putIfAbsent("ventre", () => value.toDouble());
              break;

            case "hanches":
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
        photoUrl: url, poids: poids, mesures: mesures, date: date, photoName: photoName);
  }

  Future<String> uploadPhoto(String filePath, String fileName) async {
    File file = File(filePath);

    await firebase_storage.FirebaseStorage.instance
        .ref(_user.id + '/photos/' + fileName + '.png')
        .putFile(file);

    String url = await firebase_storage.FirebaseStorage.instance
        .ref(_user.id + '/photos/' + fileName + '.png')
        .getDownloadURL();

    return url;
  }

  Future<void> supprPhoto(DetailPhoto photo) async {
    await firebase_storage.FirebaseStorage.instance.ref().child(_user.id).child('photos').child(photo.photoName+'.png').delete();

    await firestore
        .collection('patient')
        .doc(_user.id)
        .collection('poids_mesures')
        .where('photoUrl', isEqualTo: photo.photoUrl)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              element.reference.set(
                {"photoUrl": ""},
                SetOptions(merge: true),
              );
            },
          ),
        );
  }
}
