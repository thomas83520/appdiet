import 'package:appdiet/data/models/Day_comments.dart';
import 'package:appdiet/data/models/journal.dart';
import 'package:appdiet/data/models/repas.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ValidateRepasFailure implements Exception {}

class AddRepasFailure implements Exception {}

class JournalRepository {
  JournalRepository({FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<Journal> journalByDate(String date, String uid) {
    return _firestore
        .collection('patient')
        .doc(uid)
        .collection('Journal')
        .doc(date)
        .snapshots()
        .map(
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

  Future<DayComments> commentsById(String date, String userId, String commentsId) async {
    return await _firestore
        .collection('patient')
        .doc(userId)
        .collection('Journal')
        .doc(date)
        .collection('Comments')
        .doc(commentsId)
        .get()
        .then((snapshot) => snapshot.exists ? snapshot.toComments : DayComments.empty);
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
          .update({
        "Meals": FieldValue.arrayUnion([
          {"nom": repas.name, "id": repasId, "heure": repas.heure}
        ])
      });
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
        print(mealsList);
        var index;
        mealsList.asMap().forEach((key, value) {
          if (value['id'] == repasId) index = key;
        });
        print(index);
        mealsList.length == 1
            ? mealsList = [
                {"heure": repas.heure, "id": repasId, "nom": repas.name}
              ]
            : mealsList.replaceRange(index, index + 1, [
                {"heure": repas.heure, "id": repasId, "nom": repas.name}
              ]);
        print(mealsList.toString());
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

  int getIdRepasinArray(DocumentSnapshot snapshot, String idRepas) {
    List<dynamic> meals = snapshot.get("Meals");
    int id = 0;
    for (Map<String, dynamic> meal in meals) {
      if (meal["id"] == idRepas) return id;
      id++;
    }

    return -1;
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
            : listCommentaires = DayComments.fromSnapshot(this.data()["Comments"]);
    String date;
    this.data()["date"] == null 
    ? date = "" : date = this.data()["date"];
    return Journal(
        mapCommentaires: listCommentaires,
        mapRepas: listRepas,
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
      name: this.data()["name"],
      heure: this.data()["heure"],
      contenu: this.data()["contenu"],
    );
  }
}
