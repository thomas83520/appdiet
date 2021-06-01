import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/data/repository/poids_mesures_repository.dart';
import 'package:appdiet/logic/cubits/add_mesures_cubits/add_mesures_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockPoidsMesuresRepository extends Mock
    implements PoidsMesuresRepository {}

// ignore: must_be_immutable
class MockFile extends Mock implements PickedFile {}

main() {
  PhotosRepository photosRepository;
  PoidsMesuresRepository poidsMesuresRepository;
  PickedFile file = PickedFile('');
  DateTime date;
  setUp(() {
    photosRepository = MockPhotosRepository();
    poidsMesuresRepository = MockPoidsMesuresRepository();
  });
  group('Add  Mesures', () {
    date = DateTime.now();
    blocTest('Return error if repository throw on upload',
        build: () {
          when(photosRepository.uploadPhoto('', date.toString()))
              .thenThrow(Exception('oops'));
          return AddMesuresCubit(photosRepository, poidsMesuresRepository);
        },
        seed: AddMesuresState(file: file, date: date),
        act: (AddMesuresCubit cubit) async => cubit.addMesures(),
        expect: <AddMesuresState>[
          AddMesuresState(
              file: file,
              date: date,
              formState: AddMesureFormState.loadInProgress),
          AddMesuresState(
              file: file, date: date, formState: AddMesureFormState.error)
        ]);

    blocTest('Return error if repo throw on add mesures',
        build: () {
          when(poidsMesuresRepository
                  .addPoidsMesures({"mesures": {}, "date": null}, ''))
              .thenThrow(Exception('oops'));
          return AddMesuresCubit(photosRepository, poidsMesuresRepository);
        },
        seed: AddMesuresState(),
        act: (AddMesuresCubit cubit) async => cubit.addMesures(),
        expect: <AddMesuresState>[
          AddMesuresState(formState: AddMesureFormState.loadInProgress),
          AddMesuresState(formState: AddMesureFormState.error)
        ]);

    blocTest('Return complete if no throw from repo',
        build: () {
          when(poidsMesuresRepository
                  .addPoidsMesures({"mesures": {}, "date": date.toString()}, ''))
              .thenAnswer((_) => Future.value());
          when(photosRepository.uploadPhoto('', date.toString()))
              .thenAnswer((_) => Future.value(''));
          return AddMesuresCubit(photosRepository, poidsMesuresRepository);
        },
        seed: AddMesuresState(file: file, date: date),
        act: (AddMesuresCubit cubit) async => cubit.addMesures(),
        expect: <AddMesuresState>[
          AddMesuresState(file: file, date: date,formState: AddMesureFormState.loadInProgress),
          AddMesuresState(file: file, date: date,formState: AddMesureFormState.complete)
        ]);
  });
}
