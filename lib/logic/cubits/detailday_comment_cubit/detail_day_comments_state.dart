part of 'detail_day_comments_cubit.dart';

enum SubmissionStatus {loading,success,failure,dirty}

class DetailDayCommentsState extends Equatable {
  const DetailDayCommentsState({this.dayComments,this.status=SubmissionStatus.dirty});

  final DayComments dayComments;
  final SubmissionStatus status;

  @override
  List<Object> get props => [dayComments,status];

  DetailDayCommentsState copyWith(
      {String nameRepas,
      String heure,
      int before,
      int satiete,
      String commentaire,
      String contenu,
      SubmissionStatus status}) {
    return DetailDayCommentsState(
        dayComments: DayComments(
            id: this.dayComments.id,
            titre: nameRepas ?? this.dayComments.titre,
            heure: heure ?? this.dayComments.heure,
            contenu: contenu ?? this.dayComments.contenu,),
            status: status ?? this.status);
  }
}
