import 'package:appdiet/data/models/poids_mesures/poids_mesures.dart';
import 'package:appdiet/data/repository/poids_mesures_repository.dart';
import 'package:appdiet/logic/cubits/poids_mesures/poidsmesures_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPoidsMesuresRepository extends Mock
    implements PoidsMesuresRepository {}


main() {

  PoidsMesuresRepository poidsMesuresRepository;

  setUp((){
    poidsMesuresRepository = MockPoidsMesuresRepository();
  });
  group('Load Poids Mesures', (){
    blocTest('Should emit poids mesures failure when repo throw', build: (){
      when(poidsMesuresRepository.loadPoidsMesures()).thenThrow(Exception('oops'));
      return PoidsMesuresCubit(poidsMesuresRepository: poidsMesuresRepository);
    },
    act: (PoidsMesuresCubit cubit) async => cubit.loadPoidsMesures(),
    expect: <PoidsMesuresState>[
      PoidsMesuresLoadInProgress(),
      PoidsMesuresLoadFailure()
    ]);

    blocTest('Should emit poids mesures success when repo return poids mesures', build: (){
      when(poidsMesuresRepository.loadPoidsMesures()).thenAnswer((_) => Future.value(PoidsMesures()));
      return PoidsMesuresCubit(poidsMesuresRepository: poidsMesuresRepository);
    },
    act: (PoidsMesuresCubit cubit) async => cubit.loadPoidsMesures(),
    expect: <PoidsMesuresState>[
      PoidsMesuresLoadInProgress(),
      PoidsMesuresLoadSuccess(poidsMesures: PoidsMesures())
    ]);

  });
}
