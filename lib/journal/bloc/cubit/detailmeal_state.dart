part of 'detailmeal_cubit.dart';

enum SubmissionStatus {loading,success,failure,dirty}

class DetailmealState extends Equatable {
  const DetailmealState({this.repas,this.status=SubmissionStatus.dirty});

  final Repas repas;
  final SubmissionStatus status;

  @override
  List<Object> get props => [repas,status];

  DetailmealState copyWith(
      {String nameRepas,
      String heure,
      int before,
      int satiete,
      String commentaire,
      String contenu,
      SubmissionStatus status}) {
    return DetailmealState(
        repas: Repas(
            id: this.repas.id,
            name: nameRepas ?? this.repas.name,
            before: before ?? this.repas.before,
            satiete: satiete ?? this.repas.satiete,
            heure: heure ?? this.repas.heure,
            contenu: contenu ?? this.repas.contenu,
            commentaire: commentaire ?? this.repas.commentaire),
            status: status ?? this.status);
  }
}
