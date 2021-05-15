part of 'photo_detail_cubit.dart';

abstract class PhotoDetailState extends Equatable {
  const PhotoDetailState();

  @override
  List<Object> get props => [];
}

class PhotoDetailInitial extends PhotoDetailState {}

class PhotoDetailLoadInProgress extends PhotoDetailState{}

class PhotoDetailLoadSuccess extends PhotoDetailState{
  PhotoDetailLoadSuccess({@required this.detailPhoto});

  final DetailPhoto detailPhoto;

  @override
  List<Object> get props => [detailPhoto];
}

class PhotoDetailLoadFailure extends PhotoDetailState{}

class PhotoDetailDelete extends PhotoDetailState{}