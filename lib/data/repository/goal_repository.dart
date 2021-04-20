import 'package:appdiet/data/models/goal/goals.dart';
import 'package:appdiet/logic/blocs/goal_bloc/goal_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalRepository {
  GoalRepository({FirebaseFirestore firestore, User user})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        assert(user != null && user != User.empty),
        _user = user;

  final FirebaseFirestore _firestore;
  final User _user;

  Stream<Goals> getGoals() {
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
    this.data()["pourcentageShort"] == null
        ? pourcentageShort = 0
        : pourcentageShort = this.get("pourcentageShort").toDouble();

    double pourcentageLong;
    this.data()["pourcentageLong"] == null
        ? pourcentageLong = 0
        : pourcentageLong = this.get("pourcentageLong").toDouble();

    List<Goal> shortTerm;
    this.data()["shortTerm"] == null
        ? shortTerm = []
        : this.data()["shortTerm"] == ""
            ? shortTerm = []
            : shortTerm = Goal.fromSnapshot(this.data()["shortTerm"]);

    List<Goal> longTerm;
    this.data()["longTerm"] == null
        ? longTerm = []
        : this.data()["longTerm"] == ""
            ? longTerm = []
            : longTerm = Goal.fromSnapshot(this.data()["longTerm"]);

    return Goals(
        pourcentageShort: pourcentageShort,
        pourcentageLong: pourcentageLong,
        shortTerm: shortTerm,
        longTerm: longTerm);
  }
}
