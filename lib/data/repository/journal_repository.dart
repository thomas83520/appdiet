import 'dart:io';

import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/journal.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/logic/tools/stringformatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class ValidateRepasFailure implements Exception {}

class AddRepasFailure implements Exception {}

class AddDayCommentsFailure implements Exception {}

class JournalRepository {
  JournalRepository()
      : _firestore = FirebaseFirestore.instance,
        _firebaseStorage = FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  Future<Journal> journalByDate(DateTime date, String uid) async {
    print("date " + date.toString());
    String dateString = stringDate(date);
    print("dateString " + dateString);
    return await _firestore
        .collection('patient')
        .doc(uid)
        .collection('Journal')
        .doc(dateString)
        .get()
        .then((snapshot) => snapshot.exists
            ? snapshot.toJournal
            : Journal(
                date: date,
                mapCommentaires: [],
                mapRepas: [],
                wellBeing: WellBeing.empty,
              ));
  }

  Future<Repas> repasById(DateTime date, String userId, String repasId) async {
    print("date " + date.toString());
    String dateString = stringDate(date);
    print("dateString " + dateString);
    return await _firestore
        .collection('patient')
        .doc(userId)
        .collection('Journal')
        .doc(dateString)
        .collection('Repas')
        .doc(repasId)
        .get()
        .then((snapshot) => snapshot.exists ? snapshot.toRepas : Repas.empty);
  }

  Future<DayComments> commentsById(
      DateTime date, String userId, String commentsId) async {
    String dateString = stringDate(date);
    return await _firestore
        .collection('patient')
        .doc(userId)
        .collection('Journal')
        .doc(dateString)
        .collection('Comments')
        .doc(commentsId)
        .get()
        .then((snapshot) =>
            snapshot.exists ? snapshot.toComments : DayComments.empty);
  }

  Future<void> validateRepas(
      Repas repas, User user, DateTime date, String photoUrl) async {
    try {
      repas.id == Repas.empty.id
          ? await ajoutRepasToJournal(repas, user, date, photoUrl)
          : await updateRepasToJournal(repas, user, repas.id, date, photoUrl);
    } on Exception {
      throw ValidateRepasFailure();
    }
  }

  Future<void> ajoutRepasToJournal(
      Repas repas, User user, DateTime date, String photoUrl) async {
    print("date " + date.toString());
    String dateString = stringDate(date);
    print("dateString " + dateString);
    try {
      final docRef = await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .collection("Repas")
          .add(repas.toDocuments(photoUrl));
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .collection("Repas")
          .doc(docRef.id)
          .update({"id": docRef.id});
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .set({
        "Meals": FieldValue.arrayUnion([
          {"nom": repas.name, "id": docRef.id, "heure": repas.heure,"date" : date,"photoUrl":photoUrl}
        ]),
        "date": date,
      }, SetOptions(merge: true));

      //Dashboard diet
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("nouveautes")
          .add({
        "patientId": user.id,
        "patientName": user.completeName,
        "type": "NewRepas",
        "dateRepas": date,
        "photoUrl": photoUrl,
        "repasId": docRef.id,
        "repasName": repas.name,
        "dateAjout": DateTime.now(),
      });
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> updateRepasToJournal(Repas repas, User user, String repasId,
      DateTime date, String photoUrl) async {
    print("date " + date.toString());
    String dateString = stringDate(date);
    print("dateString " + dateString);
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .collection("Repas")
          .doc(repas.id)
          .set(repas.toDocuments(photoUrl));
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .get()
          .then((snapshot) async {
        List<dynamic> mealsList = snapshot.get('Meals');
        var index;
        mealsList.asMap().forEach((key, value) {
          if (value['id'] == repasId) index = key;
        });
        mealsList.length == 1
            ? mealsList = [
                {"heure": repas.heure, "id": repasId, "nom": repas.name,"date": date,photoUrl:photoUrl}
              ]
            : mealsList.replaceRange(index, index + 1, [
                {"heure": repas.heure, "id": repasId, "nom": repas.name,"date": date,photoUrl:photoUrl}
              ]);
        await _firestore
            .collection("patient")
            .doc(user.id)
            .collection("Journal")
            .doc(dateString)
            .update({"Meals": mealsList});
      });

      //Dashboard diet
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("nouveautes")
          .add({
        "patientId": user.id,
        "patientName": user.completeName,
        "type": "ModifyRepas",
        "dateRepas": date,
        "repasId": repasId,
        "photoUrl": photoUrl,
        "repasName": repas.name,
        "dateAjout": DateTime.now(),
      });
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> validateDayComments(
      DayComments dayComments, User user, DateTime date) async {
    String dateString = stringDate(date);
    try {
      dayComments.id == DayComments.empty.id
          ? await _firestore
              .collection("patient")
              .doc(user.id)
              .collection("Journal")
              .doc(dateString)
              .collection("Comments")
              .add(dayComments.toDocuments())
              .then((docRef) =>
                  ajoutDayCommentsToJournal(dayComments, user, docRef.id, date))
          : await _firestore
              .collection("patient")
              .doc(user.id)
              .collection("Journal")
              .doc(dateString)
              .collection("Comments")
              .doc(dayComments.id)
              .set(dayComments.toDocuments())
              .then((_) => updateDayCommentsToJournal(
                  dayComments, user, dayComments.id, date));
    } on Exception {
      throw ValidateRepasFailure();
    }
  }

  Future<void> validateWellbeing(
      WellBeing wellBeing, User user, DateTime date) async {
    String dateString = stringDate(date);
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .set({"Wellbeing": wellBeing.toDocuments(), "date": date},
              SetOptions(merge: true));
    } on Exception {
      throw ValidateRepasFailure();
    }
  }

  Future<void> ajoutDayCommentsToJournal(DayComments dayComments, User user,
      String dayCommentsId, DateTime date) async {
    String dateString = stringDate(date);
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .set({
        "Comments": FieldValue.arrayUnion([
          {
            "titre": dayComments.titre,
            "id": dayCommentsId,
            "heure": dayComments.heure
          }
        ]),
        "date": date,
      }, SetOptions(merge: true));
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .collection("Comments")
          .doc(dayCommentsId)
          .update({"id": dayCommentsId});
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> updateDayCommentsToJournal(DayComments dayComments, User user,
      String dayCommentsId, DateTime date) async {
    String dateString = stringDate(date);
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(dateString)
          .get()
          .then((snapshot) async {
        List<dynamic> dayCommentsList = snapshot.get('Comments');
        var index;
        dayCommentsList.asMap().forEach((key, value) {
          if (value['id'] == dayCommentsId) index = key;
        });
        dayCommentsList.length == 1
            ? dayCommentsList = [
                {
                  "heure": dayComments.heure,
                  "id": dayCommentsId,
                  "titre": dayComments.titre
                }
              ]
            : dayCommentsList.replaceRange(index, index + 1, [
                {
                  "heure": dayComments.heure,
                  "id": dayCommentsId,
                  "titre": dayComments.titre
                }
              ]);
        await _firestore
            .collection("patient")
            .doc(user.id)
            .collection("Journal")
            .doc(dateString)
            .update({"Comments": dayCommentsList});
      });
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<String> uploadPhoto(
      User user, String filePath, String fileName) async {
    File file = File(filePath);
    fileName = StringFormatter.removeDiacritics(fileName)
        .replaceAll(new RegExp(r'[^\w]+'), '_');
    Reference ref =
        _firebaseStorage.ref(user.id + '/repas/' + fileName + '.png');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> getPhotoUrl(User user, String fileName) async {
    String url = await _firebaseStorage
        .ref(user.id + '/repas/' + fileName + '.png')
        .getDownloadURL();
    return url;
  }

  String stringDate(DateTime date) {
    print("Function string date" +
        DateFormat("yyyy-MM-dd HH:mm:ss.S'Z'").format(date));
    print("Function string date" +
        Timestamp.fromDate(DateTime.parse(
                DateFormat("yyyy-MM-dd HH:mm:ss.S'Z'").format(date)))
            .millisecondsSinceEpoch
            .toString());
    return Timestamp.fromDate(DateTime.parse(
                DateFormat("yyyy-MM-dd HH:mm:ss.S'Z'").format(date)))
            .millisecondsSinceEpoch
            .toString();
  }
}

extension on DocumentSnapshot {
  Journal get toJournal {
    Map<String, dynamic> data = (this.data() as Map<String, dynamic>);
    print(data);
    List<Repas> listRepas;
    this.get("Meals") == null
        ? listRepas = []
        : this.get("Meals") == ""
            ? listRepas = []
            : listRepas = Repas.fromSnapshot(this.get("Meals"));

    List<DayComments> listCommentaires;

    data.containsKey("Comments")
        ? this.get("Comments") == ""
            ? listCommentaires = []
            : listCommentaires = DayComments.fromSnapshot(this.get("Comments"))
        : listCommentaires = [];
    DateTime date;
    data.containsKey("date")
        ? date = (this.get("date") as Timestamp).toDate()
        : date = DateTime.now();

    WellBeing wellBeing;
    data.containsKey("Wellbeing")
        ? wellBeing = WellBeing.fromSnapshot(this.get("Wellbeing"))
        : wellBeing = WellBeing.empty;
    return Journal(
        mapCommentaires: listCommentaires,
        mapRepas: listRepas,
        wellBeing: wellBeing,
        date: date);
  }

  Repas get toRepas {
    Map<String, dynamic> data = (this.data() as Map<String, dynamic>);
    print(this.data());

    return Repas(
        id: this.get("id"),
        name: this.get("name"),
        heure: this.get("heure"),
        before: this.get("before"),
        satiete: this.get("satiete"),
        contenu: this.get("contenu"),
        commentaire: this.get("commentaire"),
        photoName: this.get('photoName'),
        photoUrl: data.containsKey('photoUrl') ? this.get('photoUrl') : '');
  }

  DayComments get toComments {
    return DayComments(
      id: this.get("id"),
      titre: this.get("titre"),
      heure: this.get("heure"),
      contenu: this.get("contenu"),
    );
  }
}
