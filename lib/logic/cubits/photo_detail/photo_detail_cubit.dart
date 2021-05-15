import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'photo_detail_state.dart';

class PhotoDetailCubit extends Cubit<PhotoDetailState> {
  PhotoDetailCubit({PhotosRepository photosRepository})
      : assert(photosRepository != null),
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
}
