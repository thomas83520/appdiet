import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/cubits/detailday_comment_cubit/detail_day_comments_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockJournalRepository extends Mock implements JournalRepository {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

// ignore: must_be_immutable
class MockDayComment extends Mock implements DayComments {}

void main() {
  JournalRepository journalRepository;
  User user;
  DayComments dayComments;

  setUp(() {
    journalRepository = MockJournalRepository();
    user = MockUser();
    dayComments = MockDayComment();
  });

  group('Valid Day comment', () {
    String date = DateTime.now().toString();
    blocTest('Emit fail if repository throw',
        build: () {
          when(journalRepository.validateDayComments(
                  DayComments(
                      id: null, titre: null, heure: null, contenu: null),
                  user,
                  date))
              .thenThrow(Exception('oops'));
          return DetailDayCommentsCubit(
              date: date,
              journalRepository: journalRepository,
              user: user,
              dayComments: dayComments);
        },
        act: (DetailDayCommentsCubit cubit) async =>
            cubit.validateDayComments(),
        expect: <DetailDayCommentsState>[
          DetailDayCommentsState(
              dayComments: DayComments(), status: SubmissionStatus.loading),
          DetailDayCommentsState(
              dayComments: DayComments(), status: SubmissionStatus.failure)
        ]);

        blocTest('Emit success if repository do not throw',
        build: () {
          when(journalRepository.validateDayComments(
                  DayComments(
                      id: null, titre: null, heure: null, contenu: null),
                  user,
                  date))
              .thenAnswer((_) => Future.value());
          return DetailDayCommentsCubit(
              date: date,
              journalRepository: journalRepository,
              user: user,
              dayComments: dayComments);
        },
        act: (DetailDayCommentsCubit cubit) async =>
            cubit.validateDayComments(),
        expect: <DetailDayCommentsState>[
          DetailDayCommentsState(
              dayComments: DayComments(), status: SubmissionStatus.loading),
          DetailDayCommentsState(
              dayComments: DayComments(), status: SubmissionStatus.success)
        ]);
  });
}
