part of 'detailmeal_cubit.dart';

enum SubmissionStatus { loading, success, failure, dirty }

class DetailmealState extends Equatable {
  const DetailmealState(
      {required this.repas,
      this.status = SubmissionStatus.dirty,
      required this.file,});

  final Repas repas;
  final SubmissionStatus status;
  final XFile file;

  @override
  List<Object> get props => [repas, status];

  DetailmealState copyWith({
    String? nameRepas,
    String? heure,
    int? before,
    int? satiete,
    String? commentaire,
    String? contenu,
    String? photoName,
    String? photoUrl,
    SubmissionStatus? status,
    XFile? file,
  }) {
    return DetailmealState(
        repas: Repas(
          id: this.repas.id,
          name: nameRepas ?? this.repas.name,
          before: before ?? this.repas.before,
          satiete: satiete ?? this.repas.satiete,
          heure: heure ?? this.repas.heure,
          contenu: contenu ?? this.repas.contenu,
          commentaire: commentaire ?? this.repas.commentaire,
          photoName: photoName ?? this.repas.photoName,
          photoUrl: photoUrl ?? this.repas.photoUrl,
        ),
        status: status ?? this.status,
        file: file ?? this.file,);
  }
}
