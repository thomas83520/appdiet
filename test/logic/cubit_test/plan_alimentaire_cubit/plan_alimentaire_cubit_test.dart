import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:appdiet/data/repository/plan_alimentaire_repository.dart';
import 'package:appdiet/logic/cubits/plan_alimentaire/plan_alimentaire_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPlanAlimentaireRepository extends Mock
    implements PlanAlimentaireRepository {}

main() {
  PlanAlimentaireRepository planAlimentaireRepository;
  PDFDocument pdfDocument = PDFDocument();
  setUp(() {
    planAlimentaireRepository = MockPlanAlimentaireRepository();
  });
  group('Load Document', () {
    blocTest('Should emit plan alimentaire failure when repo throw',
        build: () {
          when(planAlimentaireRepository.loadDocument())
              .thenThrow(Exception('oops'));
          return PlanAlimentaireCubit(
              planAlimentaireRepository: planAlimentaireRepository);
        },
        act: (PlanAlimentaireCubit cubit) async => cubit.loadDocument(),
        expect: <PlanAlimentaireState>[
          PlanAlimentaireLoadInProgress(),
          PlanAlimentaireLoadFailure()
        ]);

    blocTest(
      'Should emit plan alimentaire success when repo return document',
      build: () {
        when(planAlimentaireRepository.loadDocument())
            .thenAnswer((_) => Future.value(pdfDocument));
        return PlanAlimentaireCubit(
            planAlimentaireRepository: planAlimentaireRepository);
      },
      act: (PlanAlimentaireCubit cubit) async => cubit.loadDocument(),
      expect: <PlanAlimentaireState>[
        PlanAlimentaireLoadInProgress(),
        PlanAlimentaireLoadSuccess(document: pdfDocument)
      ],
    );
  });
}
