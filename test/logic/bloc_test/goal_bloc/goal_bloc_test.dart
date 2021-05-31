import 'package:appdiet/data/models/goal/goals.dart';
import 'package:appdiet/data/repository/goal_repository.dart';
import 'package:appdiet/logic/blocs/goal_bloc/goal_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

// ignore: must_be_immutable
class MockGoals extends Mock implements Goals {}

void main() {
  GoalRepository goalRepository;
  setUp(() {
    goalRepository = MockGoalRepository();
    when(goalRepository.goals).thenAnswer(
      (_) => Stream.empty(),
    );
  });
  final goals = MockGoals();
  group('GoalLoaded', () {
    test('initial state is unknown when stream is empty', () {
      expect(
        GoalBloc(goalRepository: goalRepository).state,
        GoalState.unknown(),
      );
    });
    blocTest('inital state is complete when stream return goal ', build: () {
      when(goalRepository.goals).thenAnswer((_) => Stream<Goals>.value(goals));
      return GoalBloc(goalRepository: goalRepository);
    }, expect: <GoalState>[GoalState.complete(goals)]);
  });

  group('Goal Selected', () {
    blocTest('Should emit error when repository throw',
        build: () {
          when(goalRepository.goalClicked(1, GoalType.longTerm, goals))
              .thenThrow(Exception('oops'));
          return GoalBloc(goalRepository: goalRepository);
        },
        act: (GoalBloc bloc) async => bloc
            .add(GoalSelected(id: 1, goals: goals, type: GoalType.longTerm)),
        expect: <GoalState>[
          GoalState.error(),
        ]);
    
    blocTest('Should not emit when repository return void', build: (){
      when(goalRepository.goalClicked(1, GoalType.longTerm, goals)).thenAnswer((_) => Future.value());
      return GoalBloc(goalRepository: goalRepository);
    },
    act: (GoalBloc bloc) async => bloc.add(GoalSelected(id: 1,type: GoalType.longTerm,goals: goals)),
    expect: <GoalState> []);
  });
}
