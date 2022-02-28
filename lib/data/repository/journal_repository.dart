import 'dart:io';

import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/journal.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/logic/tools/stringformatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ValidateRepasFailure implements Exception {}

class AddRepasFailure implements Exception {}

class AddDayCommentsFailure implements Exception {}

class JournalRepository {
  JournalRepository()
      : _firestore = FirebaseFirestore.instance,
        _firebaseStorage = FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  Future<Journal> journalByDate(String date, String uid) async {
    return await _firestore
        .collection('patient')
        .doc(uid)
        .collection('Journal')
        .doc(date)
        .get()
        .then(
            (snapshot) => snapshot.exists ? snapshot.toJournal : Journal.empty);
  }

  Future<Repas> repasById(String date, String userId, String repasId) async {
    return await _firestore
        .collection('patient')
        .doc(userId)
        .collection('Journal')
        .doc(date)
        .collection('Repas')
        .doc(repasId)
        .get()
        .then((snapshot) => snapshot.exists ? snapshot.toRepas : Repas.empty);
  }

  Future<DayComments> commentsById(
      String date, String userId, String commentsId) async {
    return await _firestore
        .collection('patient')
        .doc(userId)
        .collection('Journal')
        .doc(date)
        .collection('Comments')
        .doc(commentsId)
        .get()
        .then((snapshot) =>
            snapshot.exists ? snapshot.toComments : DayComments.empty);
  }

  Future<void> validateRepas(Repas repas, User user, String date) async {
    try {
      repas.id == Repas.empty.id
          ? ajoutRepasToJournal(repas, user, date)
          : updateRepasToJournal(repas, user, repas.id, date);
    } on Exception {
      throw ValidateRepasFailure();
    }
  }

  Future<void> ajoutRepasToJournal(Repas repas, User user, String date) async {
    try {
      final docRef = await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .collection("Repas")
          .add(repas.toDocuments());
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .collection("Repas")
          .doc(docRef.id)
          .update({"id": docRef.id});
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .set({
        "Meals": FieldValue.arrayUnion([
          {"nom": repas.name, "id": docRef.id, "heure": repas.heure}
        ]),
        "date": date,
      }, SetOptions(merge: true));


      //Dashboard diet
      final querySnap = await _firestore
          .collection("dieteticien")
          .where("uidDiet", isEqualTo: user.uidDiet)
          .get();
      final dietID = querySnap.docs.first.id;
      await _firestore
          .collection("dieteticien")
          .doc(dietID)
          .collection("notificationRepas")
          .add({
        "patientId": user.id,
        "patientName": user.completeName,
        "type": "add",
        "repasId": docRef.id,
        "repasName" : repas.name,
        "dateRepas": date,
        "dateAjout": DateTime.now(),
      });
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> updateRepasToJournal(
      Repas repas, User user, String repasId, String date) async {
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .collection("Repas")
          .doc(repas.id)
          .set(repas.toDocuments());
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .get()
          .then((snapshot) async {
        List<dynamic> mealsList = snapshot.get('Meals');
        var index;
        mealsList.asMap().forEach((key, value) {
          if (value['id'] == repasId) index = key;
        });
        mealsList.length == 1
            ? mealsList = [
                {"heure": repas.heure, "id": repasId, "nom": repas.name}
              ]
            : mealsList.replaceRange(index, index + 1, [
                {"heure": repas.heure, "id": repasId, "nom": repas.name}
              ]);
        await _firestore
            .collection("patient")
            .doc(user.id)
            .collection("Journal")
            .doc(date)
            .update({"Meals": mealsList});
      });


      //Dashboard diet
      final querySnap = await _firestore
          .collection("dieteticien")
          .where("uidDiet", isEqualTo: user.uidDiet)
          .get();
      final dietID = querySnap.docs.first.id;
      await _firestore
          .collection("dieteticien")
          .doc(dietID)
          .collection("notificationRepas")
          .add({
        "patientId": user.id,
        "patientName": user.completeName,
        "type": "update",
        "repasId": repasId,
        "repasName" : repas.name,
        "dateRepas": date,
        "dateAjout": DateTime.now(),
      });

    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> validateDayComments(
      DayComments dayComments, User user, String date) async {
    try {
      dayComments.id == DayComments.empty.id
          ? await _firestore
              .collection("patient")
              .doc(user.id)
              .collection("Journal")
              .doc(date)
              .collection("Comments")
              .add(dayComments.toDocuments())
              .then((docRef) =>
                  ajoutDayCommentsToJournal(dayComments, user, docRef.id, date))
          : await _firestore
              .collection("patient")
              .doc(user.id)
              .collection("Journal")
              .doc(date)
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
      WellBeing wellBeing, User user, String date) async {
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .set({"Wellbeing": wellBeing.toDocuments(), "date": date},
              SetOptions(merge: true));
    } on Exception {
      throw ValidateRepasFailure();
    }
  }

  Future<void> ajoutDayCommentsToJournal(DayComments dayComments, User user,
      String dayCommentsId, String date) async {
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
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
          .doc(date)
          .collection("Comments")
          .doc(dayCommentsId)
          .update({"id": dayCommentsId});
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> updateDayCommentsToJournal(DayComments dayComments, User user,
      String dayCommentsId, String date) async {
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
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
            .doc(date)
            .update({"Comments": dayCommentsList});
      });
    } on Exception {
      throw AddRepasFailure();
    }
  }

  Future<void> uploadPhoto(User user, String filePath, String fileName) async {
    File file = File(filePath);
    fileName = StringFormatter.removeDiacritics(fileName)
        .replaceAll(new RegExp(r'[^\w]+'), '_');
    await _firebaseStorage
        .ref(user.id + '/repas/' + fileName + '.png')
        .putFile(file);
  }

  Future<String> getPhotoUrl(User user, String fileName) async {
    String url = await _firebaseStorage
        .ref(user.id + '/repas/' + fileName + '.png')
        .getDownloadURL();
    return url;
  }
}

extension on DocumentSnapshot {
  Journal get toJournal {
    Map<String, dynamic> data = (this.data() as Map<String, dynamic>);

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
    String date;
    data.containsKey("date") ? date = this.get("date") : date = "";

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
    return Repas(
        id: this.get("id"),
        name: this.get("name"),
        heure: this.get("heure"),
        before: this.get("before"),
        satiete: this.get("satiete"),
        contenu: this.get("contenu"),
        commentaire: this.get("commentaire"),
        photoName: this.get('photoName'));
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
