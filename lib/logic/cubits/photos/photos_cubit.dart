import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photos_state.dart';

class PhotosCubit extends Cubit<PhotosState> {
  PhotosCubit({required PhotosRepository photosRepository})
      : 
        _photosRepository = photosRepository,
        super(PhotosInitial());

  final PhotosRepository _photosRepository;

  Future<void> loadimages() async {
    emit(PhotosLoadInProgress());
    try{
      List<DetailPhoto> photosUrl = await _photosRepository.loadPhotos();
      emit(PhotosLoadSuccess(photosUrl: photosUrl));
    }catch (e){
      emit(PhotosLoadFailure());
    }
  }
}
