import 'package:appdiet/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalRepository {
  GoalRepository({required User user})
      : _firestore = FirebaseFirestore.instance,
        _user = user;

  final FirebaseFirestore _firestore;
  final User _user;

  Stream<Goals> get goals {
    return _firestore
        .collection("patient")
        .doc(_user.id)
        .collection("objectifs")
        .doc("objectifs")
        .snapshots()
        .map((snapshot) => snapshot.exists ? snapshot.toGoals : Goals.empty);
  }

  Future<void> goalClicked(int id, GoalType type, Goals goals) async {
    goals = modifyGoals(id, type, goals);

    return await _firestore
        .collection("patient")
        .doc(_user.id)
        .collection("objectifs")
        .doc("objectifs")
        .set(goals.toJson());
  }

  Goals modifyGoals(int id, GoalType type, Goals goals) {
    List<Goal> newListe;
    if (type == GoalType.shortTerm)
      newListe = goals.shortTerm;
    else
      newListe = goals.longTerm;

    newListe[id] = newListe[id].copywith(isDone: !newListe[id].isDone);

    if (type == GoalType.shortTerm)
      return goals.copyWith(shortTerm: newListe);
    else
      return goals.copyWith(longTerm: newListe);
  }
}

extension on DocumentSnapshot {
  Goals get toGoals {
    double pourcentageShort;
    this.get("pourcentageShort") == null
        ? pourcentageShort = 0
        : pourcentageShort = this.get("pourcentageShort").toDouble();

    double pourcentageLong;
    this.get("pourcentageLong") == null
        ? pourcentageLong = 0
        : pourcentageLong = this.get("pourcentageLong").toDouble();

    List<Goal> shortTerm;
    this.get("shortTerm") == null
        ? shortTerm = []
        : this.get("shortTerm") == ""
            ? shortTerm = []
            : shortTerm = Goal.fromSnapshot(this.get("shortTerm"));

    List<Goal> longTerm;
    this.get("longTerm") == null
        ? longTerm = []
        : this.get("longTerm") == ""
            ? longTerm = []
            : longTerm = Goal.fromSnapshot(this.get("longTerm"));

    return Goals(
        pourcentageShort: pourcentageShort,
        pourcentageLong: pourcentageLong,
        shortTerm: shortTerm,
        longTerm: longTerm);
  }
}
