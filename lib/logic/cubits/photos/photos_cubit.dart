import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'photos_state.dart';

class PhotosCubit extends Cubit<PhotosState> {
  PhotosCubit({@required PhotosRepository photosRepository})
      : assert(photosRepository != null),
        _photosRepository = photosRepository,
        super(PhotosInitial());

  final PhotosRepository _photosRepository;

  Future<void> loadimages() async {
    emit(PhotosLoadInProgress());
    try{
      List<String> photosUrl = await _photosRepository.loadPhotos();
      emit(PhotosLoadSuccess(photosUrl: photosUrl));
    }catch (e){
      emit(PhotosLoadFailure());
    }
  }
}
