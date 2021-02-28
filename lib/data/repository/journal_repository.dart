import 'package:appdiet/data/models/Day_comments.dart';
import 'package:appdiet/data/models/journal.dart';
import 'package:appdiet/data/models/repas.dart';
import 'package:appdiet/data/models/wellbeing.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ValidateRepasFailure implements Exception {}

class AddRepasFailure implements Exception {}

class AddDayCommentsFailure implements Exception {}

class JournalRepository {
  JournalRepository({FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

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
          ? await _firestore
              .collection("patient")
              .doc(user.id)
              .collection("Journal")
              .doc(date)
              .collection("Repas")
              .add(repas.toDocuments())
              .then(
                  (docRef) => ajoutRepasToJournal(repas, user, docRef.id, date))
          : await _firestore
              .collection("patient")
              .doc(user.id)
              .collection("Journal")
              .doc(date)
              .collection("Repas")
              .doc(repas.id)
              .set(repas.toDocuments())
              .then((_) => updateRepasToJournal(repas, user, repas.id, date));
    } on Exception {
      throw ValidateRepasFailure();
    }
  }

  Future<void> ajoutRepasToJournal(
      Repas repas, User user, String repasId, String date) async {
    try {
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .set({
        "Meals": FieldValue.arrayUnion([
          {"nom": repas.name, "id": repasId, "heure": repas.heure}
        ]),
        "date": date,
      }, SetOptions(merge: true));
      await _firestore
          .collection("patient")
          .doc(user.id)
          .collection("Journal")
          .doc(date)
          .collection("Repas")
          .doc(repasId)
          .update({"id": repasId});
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
          .get()
          .then((snapshot) async {
        List<dynamic> mealsList = snapshot.data()['Meals'];
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
        List<dynamic> dayCommentsList = snapshot.data()['Comments'];
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
}

extension on DocumentSnapshot {
  Journal get toJournal {
    List<Repas> listRepas;
    this.data()["Meals"] == null
        ? listRepas = []
        : this.data()["Meals"] == ""
            ? listRepas = []
            : listRepas = Repas.fromSnapshot(this.data()["Meals"]);

    List<DayComments> listCommentaires;
    this.data()["Comments"] == null
        ? listCommentaires = []
        : this.data()["Comments"] == ""
            ? listCommentaires = []
            : listCommentaires =
                DayComments.fromSnapshot(this.data()["Comments"]);
    String date;
    this.data()["date"] == null ? date = "" : date = this.data()["date"];
    WellBeing wellBeing;
    this.data()["Wellbeing"] == null
        ? wellBeing = WellBeing.empty
        : wellBeing = WellBeing.fromSnapshot(this.data()["Wellbeing"]);
    return Journal(
        mapCommentaires: listCommentaires,
        mapRepas: listRepas,
        wellBeing: wellBeing,
        date: date);
  }

  Repas get toRepas {
    return Repas(
      id: this.data()["id"],
      name: this.data()["name"],
      heure: this.data()["heure"],
      before: this.data()["before"],
      satiete: this.data()["satiete"],
      contenu: this.data()["contenu"],
      commentaire: this.data()["commentaire"],
    );
  }

  DayComments get toComments {
    return DayComments(
      id: this.data()["id"],
      titre: this.data()["titre"],
      heure: this.data()["heure"],
      contenu: this.data()["contenu"],
    );
  }
}
