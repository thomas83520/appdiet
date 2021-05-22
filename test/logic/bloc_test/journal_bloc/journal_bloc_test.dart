import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/journal.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:appdiet/data/repository/journal_repository.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

class MockJournalRepository extends Mock implements JournalRepository {}

class MockUser extends Mock implements User {}

class MockRepas extends Mock implements Repas {}

void main() {
  group('Journal Bloc', () {
    JournalRepository journalRepository;
    JournalBloc journalBloc;
    User user;
    Repas repas;
    Journal journal = Journal(
        mapRepas: [],
        mapCommentaires: [],
        wellBeing: WellBeing.empty,
        date: DateFormat("dd_MM_yyyy").format(DateTime.now()));

    setUp(() {
      journalRepository = MockJournalRepository();
      user = MockUser();
      repas = MockRepas();
      when(journalRepository.journalByDate(
              DateFormat("dd_MM_yyyy").format(DateTime.now()), user.id))
          .thenAnswer((_) => Future.value(journal));
      journalBloc = JournalBloc(
          journalRepository: journalRepository,
          user: user,
          date: DateFormat("dd_MM_yyyy").format(DateTime.now()));
    });

    group('Journal Date Changed ', () {
      blocTest('Should emit fail status if repository throws',
          build: () {
            when(journalRepository.journalByDate(
                    DateFormat("dd_MM_yyyy").format(DateTime.now()), user.id))
                .thenThrow(Exception('oops'));
            return journalBloc;
          },
          act: (JournalBloc bloc) async =>
              bloc.add(JournalDateChange(DateTime.now(), user)),
          expect: <JournalState>[JournalState.loading(), JournalState.fail()]);

      blocTest('Should emit Journal complete when journal by date is call',
          build: () => journalBloc,
          act: (JournalBloc bloc) async =>
              bloc.add(JournalDateChange(DateTime.now(), user)),
          expect: <JournalState>[
            JournalState.loading(),
            JournalState.complete(
                journal, DateFormat("dd_MM_yyyy").format(DateTime.now()))
          ]);
    });

    group('Journal Update', () {
      blocTest('Should emit fail status if repository throws',
          build: () {
            when(journalRepository.journalByDate(
                    DateFormat("dd_MM_yyyy").format(DateTime.now()), user.id))
                .thenThrow(Exception('oops'));
            return journalBloc;
          },
          act: (JournalBloc bloc) async => bloc
            ..add(JournalUpdate(journal,
                DateFormat("dd_MM_yyyy").format(DateTime.now()), user)),
          expect: <JournalState>[JournalState.loading(), JournalState.fail()]);

      blocTest('Should emit Journal complete ',
          build: () => journalBloc,
          act: (JournalBloc bloc) async => bloc.add(JournalUpdate(
              journal, DateFormat("dd_MM_yyyy").format(DateTime.now()), user)),
          expect: <JournalState>[
            JournalState.loading(),
            JournalState.complete(
                journal, DateFormat("dd_MM_yyyy").format(DateTime.now()))
          ]);
    });

    group('Repas Clicked', () {
      blocTest('Repas is empty',
          build: () {
            repas = Repas.empty;
            return journalBloc;
          },
          act: (JournalBloc bloc) async => bloc.add(RepasClicked(
              repas: repas,
              journal: journal,
              date: DateFormat("dd_MM_yyyy").format(DateTime.now()),
              user: user)),
          expect: <JournalState>[
            JournalState.loading(),
            JournalState.modifyRepas(Repas.empty, journal,
                DateFormat("dd_MM_yyyy").format(DateTime.now())),
          ]);

      blocTest(
        'Repas not empty, repository throw exeption',
        build: () {
          when(journalRepository.repasById(
                  DateFormat("dd_MM_yyyy").format(DateTime.now()), 'id', 'id'))
              .thenThrow(Exception('oops'));
          return journalBloc;
        },
        act: (JournalBloc bloc) async {
          repas = Repas(
              id: 'id',
              name: 'test',
              heure: 'test',
              before: 6,
              satiete: 6,
              contenu: '',
              commentaire: '');
          user = User(
              id: 'id',
              linkStorageFolder: '',
              email: '',
              firstName: '',
              creatingAccount: false,
              birthDate: '',
              uidDiet: '',
              name: '',
              linkFoodPlan: '');
          bloc.add(RepasClicked(
              repas: repas,
              journal: journal,
              date: DateFormat("dd_MM_yyyy").format(DateTime.now()),
              user: user));
        },
        verify: (_) {
          verify(journalRepository.repasById(
                  DateFormat("dd_MM_yyyy").format(DateTime.now()), 'id', 'id'))
              .called(1);
        },
        expect: <JournalState>[
          JournalState.loading(),
          JournalState.fail(),
        ],
      );

      blocTest('Repas not empty, emit modifyRepas', build: () {
        Repas repas = Repas(
            id: 'id',
            commentaire: '',
            name: '',
            heure: '',
            before: 6,
            satiete: 6,
            contenu: '');
        when(journalRepository.repasById(
                DateFormat("dd_MM_yyyy").format(DateTime.now()), 'id', 'id'))
            .thenAnswer((_) => Future.value(repas));
        return journalBloc;
      }, act: (JournalBloc bloc) async {
        repas = Repas(
            id: 'id',
            name: 'test',
            heure: 'test',
            before: 6,
            satiete: 6,
            contenu: '',
            commentaire: '');
        user = User(
            id: 'id',
            linkStorageFolder: '',
            email: '',
            firstName: '',
            creatingAccount: false,
            birthDate: '',
            uidDiet: '',
            name: '',
            linkFoodPlan: '');
        bloc.add(RepasClicked(
            repas: repas,
            journal: journal,
            date: DateFormat("dd_MM_yyyy").format(DateTime.now()),
            user: user));
      }, expect: <JournalState>[
        JournalState.loading(),
        JournalState.modifyRepas(
            Repas(
                id: 'id',
                commentaire: '',
                name: '',
                heure: '',
                before: 6,
                satiete: 6,
                contenu: ''),
            journal,
            DateFormat("dd_MM_yyyy").format(DateTime.now()))
      ]);
    });

    group('Day comment Clicked', () {
      blocTest('Day comment is empty',
          build: () {
            return journalBloc;
          },
          act: (JournalBloc bloc) async => bloc.add(DayCommentsClicked(dayComments: DayComments.empty,journal: journal,date: DateFormat("dd_MM_yyyy").format(DateTime.now()))),
          expect: <JournalState>[
            JournalState.loading(),
            JournalState.modifyDayComment(DayComments.empty, journal,
                DateFormat("dd_MM_yyyy").format(DateTime.now())),
          ]);

      blocTest(
        'DayComment not empty, repository throw exeption',
        build: () {
          when(journalRepository.commentsById(
                  DateFormat("dd_MM_yyyy").format(DateTime.now()), 'id', 'id'))
              .thenThrow(Exception('oops'));
          return journalBloc;
        },
        act: (JournalBloc bloc) async {
          DayComments dayComment = DayComments(
              id: 'id',
              titre: '',
              heure: 'test',
              contenu: '',);
          user = User(
              id: 'id',
              linkStorageFolder: '',
              email: '',
              firstName: '',
              creatingAccount: false,
              birthDate: '',
              uidDiet: '',
              name: '',
              linkFoodPlan: '');
          bloc.add(DayCommentsClicked(
              dayComments: dayComment,
              journal: journal,
              date: DateFormat("dd_MM_yyyy").format(DateTime.now()),
              user: user));
        },
        expect: <JournalState>[
          JournalState.loading(),
          JournalState.fail(),
        ],
      );

      blocTest('DayComment not empty, emit modify day comment', build: () {
        DayComments dayComment = DayComments(
              id: 'id',
              titre: '',
              heure: 'test',
              contenu: '',);
        when(journalRepository.commentsById(
                DateFormat("dd_MM_yyyy").format(DateTime.now()), 'id', 'id'))
            .thenAnswer((_) => Future.value(dayComment));
        return journalBloc;
      }, act: (JournalBloc bloc) async {
        DayComments dayComment = DayComments(
              id: 'id',
              titre: '',
              heure: 'test',
              contenu: '',);
        user = User(
            id: 'id',
            linkStorageFolder: '',
            email: '',
            firstName: '',
            creatingAccount: false,
            birthDate: '',
            uidDiet: '',
            name: '',
            linkFoodPlan: '');
        bloc.add(DayCommentsClicked(
            dayComments: dayComment,
            journal: journal,
            date: DateFormat("dd_MM_yyyy").format(DateTime.now()),
            user: user));
      }, expect: <JournalState>[
        JournalState.loading(),
        JournalState.modifyDayComment(DayComments(
              id: 'id',
              titre: '',
              heure: 'test',
              contenu: '',),
            journal,
            DateFormat("dd_MM_yyyy").format(DateTime.now()))
      ]);
    });

    group('Wellbeing clicked', () {
      blocTest('Well being clicked',
          build: () => journalBloc,
          act: (JournalBloc bloc) async => bloc.add(WellBeingClicked(journal : journal,wellBeing: WellBeing.empty,  date: DateFormat("dd_MM_yyyy").format(DateTime.now()))),
          expect: <JournalState>[
            JournalState.loading(),
            JournalState.modifyWellBeing(WellBeing.empty, journal, DateFormat("dd_MM_yyyy").format(DateTime.now())),
          ]);
    });
  });
}
