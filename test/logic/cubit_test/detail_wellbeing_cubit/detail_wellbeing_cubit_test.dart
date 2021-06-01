import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/cubits/detailwellbeing_cubit/detailwellbeing_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockJournalRepository extends Mock implements JournalRepository {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

// ignore: must_be_immutable
class MockWellBeing extends Mock implements WellBeing {}

void main() {
  JournalRepository journalRepository;
  User user;
  WellBeing wellBeing;

  setUp(() {
    journalRepository = MockJournalRepository();
    user = MockUser();
    wellBeing = MockWellBeing();
  });

  group('Valid wellBeing', () {
    String date = DateTime.now().toString();
    blocTest('Emit fail if repository throw',
        build: () {
          when(journalRepository.validateWellbeing(WellBeing(), user, date))
              .thenThrow(Exception('oops'));
          return DetailwellbeingCubit(
              journalRepository: journalRepository,
              wellBeing: wellBeing,
              user: user,
              date: date);
        },
        act: (DetailwellbeingCubit cubit) async => cubit.validateWellbeing(),
        expect: <DetailwellBeingState>[
          DetailwellBeingState(
              wellBeing: WellBeing(), status: SubmissionStatus.loading),
          DetailwellBeingState(
              wellBeing: WellBeing(), status: SubmissionStatus.failure)
        ]);

    blocTest('Emit success if repository do not throw',
        build: () {
          when(journalRepository.validateWellbeing(WellBeing(), user, date))
              .thenAnswer((_) => Future.value());
          return DetailwellbeingCubit(journalRepository: journalRepository,
              wellBeing: wellBeing,
              user: user,
              date: date);
        },
        act: (DetailwellbeingCubit cubit) async => cubit.validateWellbeing(),
        expect: <DetailwellBeingState>[
          DetailwellBeingState(
              wellBeing: WellBeing(), status: SubmissionStatus.loading),
          DetailwellBeingState(
              wellBeing: WellBeing(), status: SubmissionStatus.success)
        ]);
  });
}
