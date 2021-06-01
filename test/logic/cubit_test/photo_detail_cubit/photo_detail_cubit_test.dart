import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/cubits/photo_detail/photo_detail_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPhotosRepository extends Mock
    implements PhotosRepository {}

main() {
  PhotosRepository photosRepository;
  DetailPhoto detailPhoto = DetailPhoto();
  setUp(() {
    photosRepository = MockPhotosRepository();
  });
  group('Load detail', () {
    blocTest('Should emit photo detail failure failure when repo throw',
        build: () {
          when(photosRepository.loadDetail(''))
              .thenThrow(Exception('oops'));
          return PhotoDetailCubit(photosRepository: photosRepository);
        },
        act: (PhotoDetailCubit cubit) async => cubit.loadDetail(''),
        expect: <PhotoDetailState>[
          PhotoDetailLoadInProgress(),
          PhotoDetailLoadFailure()
        ]);

    blocTest(
      'Should emit photo detail success when repo return document',
      build: () {
        when(photosRepository.loadDetail(''))
            .thenAnswer((_) => Future.value(detailPhoto));
        return PhotoDetailCubit(photosRepository: photosRepository);
      },
      act: (PhotoDetailCubit cubit) async => cubit.loadDetail(''),
      expect: <PhotoDetailState>[
        PhotoDetailLoadInProgress(),
        PhotoDetailLoadSuccess(detailPhoto: detailPhoto)
      ],
    );
  });
}
