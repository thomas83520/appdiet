part of 'photos_cubit.dart';

abstract class PhotosState extends Equatable {
  const PhotosState();

  @override
  List<Object> get props => [];
}

class PhotosInitial extends PhotosState {}

class PhotosLoadInProgress extends PhotosState {}

class PhotosLoadSuccess extends PhotosState {
  PhotosLoadSuccess({required this.photosUrl});

  final List<DetailPhoto> photosUrl;

  @override
  List<Object> get props => [photosUrl];
}

class PhotosLoadFailure extends PhotosState {}
