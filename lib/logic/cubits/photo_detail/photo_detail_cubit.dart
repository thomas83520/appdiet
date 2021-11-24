import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photo_detail_state.dart';

class PhotoDetailCubit extends Cubit<PhotoDetailState> {
  PhotoDetailCubit({required PhotosRepository photosRepository})
      : 
        _photosRepository = photosRepository,
        super(PhotoDetailInitial());

  final PhotosRepository _photosRepository;

  Future<void> loadDetail(String url) async {
    emit(PhotoDetailLoadInProgress());
    try{
      DetailPhoto detailPhoto = await _photosRepository.loadDetail(url);
      emit(PhotoDetailLoadSuccess(detailPhoto: detailPhoto));
    }catch(e){
      emit(PhotoDetailLoadFailure());
    }
  }
  Future<void> supprPhoto(DetailPhoto photo) async {
    try{
      await _photosRepository.supprPhoto(photo);
      emit(PhotoDetailLoadInProgress());
    }catch(e){
      emit(PhotoDetailLoadFailure());
    }
  }
}
