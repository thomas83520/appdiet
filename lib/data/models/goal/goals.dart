import 'package:equatable/equatable.dart';

class Goals extends Equatable {
  const Goals(
      {this.shortTerm,
      this.longTerm,
      this.pourcentageLong,
      this.pourcentageShort});

  final List<Goal> shortTerm;
  final List<Goal> longTerm;
  final double pourcentageShort;
  final double pourcentageLong;

  static const empty = Goals(
      shortTerm: [], longTerm: [], pourcentageLong: 0, pourcentageShort: 0);

  Goals copyWith({List<Goal> shortTerm, List<Goal> longTerm}) {
    double pourcentageShort = calculatePourcentage(shortTerm ?? this.shortTerm);
    double pourcentageLong = calculatePourcentage(longTerm ?? this.longTerm);
    return Goals(
        longTerm: longTerm ?? this.longTerm,
        shortTerm: shortTerm ?? this.shortTerm,
        pourcentageShort: pourcentageShort,
        pourcentageLong: pourcentageLong);
  }

  Map<String,dynamic> toJson()
  {
    return {
      "pourcentageShort" : this.pourcentageShort,
      "pourcentageLong" : this.pourcentageLong,
      "shortTerm" : goalListToJson(this.shortTerm),
      "longTerm" : goalListToJson(this.longTerm)
    };
  }

  List<Map<String,dynamic>> goalListToJson(List<Goal> goals){
    return goals.map((goal) => {
      "goalName" : goal.goalName,
      "isDone" : goal.isDone,
    }).toList();
  }

  
  double calculatePourcentage(List<Goal> goals) {
    double nb = 0;
    if(goals.isEmpty)
      return 0;
    if(goals == null)
      return 0;
    goals.forEach((goal) {
      if (goal.isDone) nb++;
    });
    return ((nb / goals.length) * 100).roundToDouble();
  }

  @override
  List<Object> get props =>
      [shortTerm, longTerm, pourcentageShort, pourcentageLong];
}

class Goal extends Equatable {
  const Goal({this.goalName, this.isDone});

  final String goalName;
  final bool isDone;

  static List<Goal> fromSnapshot(List<dynamic> snapshot) {
    List<Goal> test = snapshot
        .map((snapshot) {
            return Goal(goalName: snapshot["goalName"], isDone: snapshot["isDone"]);})
        .toList();

        return test;
  }

  Goal copywith({
    bool isDone,
    String goalName,
  }) {
    return Goal(
      goalName: goalName ?? this.goalName,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object> get props => [goalName, isDone];
}
