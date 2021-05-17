import 'package:appdiet/data/models/goal/goals.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Goal', () {
    test('Goal instance', () {
      expect(Goal(goalName: "name", isDone: true),
          Goal(goalName: "name", isDone: true));
    });

    test('Goal from snapshot', () {
      List<dynamic> goal = [
        {"goalName": "name", "isDone": true}
      ];
      expect(Goal.fromSnapshot(goal), [Goal(goalName: "name", isDone: true)]);
    });

    test('Goal copy with', () {
      expect(
          Goal(goalName: "name", isDone: true)
              .copywith(isDone: false, goalName: "newName"),
          Goal(goalName: "newName", isDone: false));
    });
  });

  group('Goals', () {
    List<Goal> short = [Goal(goalName: "name", isDone: false)];
    List<Goal> long = [Goal(goalName: "name", isDone: false)];
    double pourcentageLong = 0.0;
    double pourcentageShort = 0.0;
    test('Goals instance', () {
      expect(
          Goals(
              shortTerm: short,
              longTerm: long,
              pourcentageLong: pourcentageLong,
              pourcentageShort: pourcentageShort),
          Goals(
              shortTerm: short,
              longTerm: long,
              pourcentageShort: pourcentageShort,
              pourcentageLong: pourcentageLong));
    });

    test('Goals empty', () {
      expect(
          Goals.empty,
          Goals(
              shortTerm: [],
              longTerm: [],
              pourcentageLong: 0,
              pourcentageShort: 0));
    });

    test('Goals copyWith', () {
      expect(
        Goals(
                longTerm: long,
                shortTerm: short,
                pourcentageLong: 0,
                pourcentageShort: 0)
            .copyWith(
                longTerm: [Goal(goalName: "newName", isDone: true)],
                shortTerm: [Goal(goalName: "newName", isDone: true)]),
        Goals(
            longTerm: [Goal(goalName: "newName", isDone: true)],
            shortTerm: [Goal(goalName: "newName", isDone: true)],
            pourcentageShort: 100.0,
            pourcentageLong: 100.0),
      );
    });

    test('Goals toJson', () {
      expect(
          Goals(
                  shortTerm: short,
                  longTerm: long,
                  pourcentageLong: 0,
                  pourcentageShort: 0)
              .toJson(),
          {
            "shortTerm": [
              {"goalName": "name", "isDone": false}
            ],
            "longTerm": [
              {"goalName": "name", "isDone": false}
            ],
            "pourcentageLong": 0,
            "pourcentageShort": 0,
          });
    });
  });
}
