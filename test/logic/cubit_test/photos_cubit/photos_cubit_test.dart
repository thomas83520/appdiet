import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/cubits/photos/photos_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPhotosRepository extends Mock
    implements PhotosRepository {}

main() {
  PhotosRepository photosRepository;
  setUp(() {
    photosRepository = MockPhotosRepository();
  });
  group('Load Photos', () {
    blocTest('Should emit photos failure failure when repo throw',
        build: () {
          when(photosRepository.loadPhotos())
              .thenThrow(Exception('oops'));
          return PhotosCubit(photosRepository: photosRepository);
        },
        act: (PhotosCubit cubit) async => cubit.loadimages(),
        expect: <PhotosState>[
          PhotosLoadInProgress(),
          PhotosLoadFailure()
        ]);

    blocTest(
      'Should emit photos success when repo return document',
      build: () {
        when(photosRepository.loadPhotos())
            .thenAnswer((_) => Future.value([]));
        return PhotosCubit(photosRepository: photosRepository);
      },
      act: (PhotosCubit cubit) async => cubit.loadimages(),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photosUrl: [])
      ],
    );
  });
}
