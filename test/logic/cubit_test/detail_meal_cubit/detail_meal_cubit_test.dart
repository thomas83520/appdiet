import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/cubits/detailmeal_cubit/detailmeal_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockJournalRepository extends Mock implements JournalRepository {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

// ignore: must_be_immutable
class MockRepas extends Mock implements Repas {}

void main() {
  JournalRepository journalRepository;
  User user;
  Repas repas;

  setUp(() {
    journalRepository = MockJournalRepository();
    user = MockUser();
    repas = MockRepas();
  });

  group('Valid repas', () {
    String date = DateTime.now().toString();
    blocTest('Emit fail if repository throw',
        build: () {
          when(journalRepository.validateRepas(Repas(), user, date))
              .thenThrow(Exception('oops'));
          return DetailmealCubit(
              journalRepository: journalRepository,
              repas: repas,
              user: user,
              date: date);
        },
        act: (DetailmealCubit cubit) async => cubit.validateRepas(),
        expect: <DetailmealState>[
          DetailmealState(repas: Repas(), status: SubmissionStatus.loading),
          DetailmealState(repas: Repas(), status: SubmissionStatus.failure)
        ]);

    blocTest('Emit success if repository do not throw',
        build: () {
          when(journalRepository.validateRepas(Repas(), user, date))
              .thenAnswer((_) => Future.value());
          return DetailmealCubit(
              journalRepository: journalRepository,
              repas: repas,
              user: user,
              date: date);
        },
        act: (DetailmealCubit cubit) async => cubit.validateRepas(),
        expect: <DetailmealState>[
          DetailmealState(repas: Repas(), status: SubmissionStatus.loading),
          DetailmealState(repas: Repas(), status: SubmissionStatus.success)
        ]);
  });
}
