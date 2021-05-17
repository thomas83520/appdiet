part of 'add_mesures_cubit.dart';

enum AddMesureFormState {writing,loadInProgress,complete,error}

class AddMesuresState extends Equatable {
  const AddMesuresState(
      {this.date,
      this.bras = 0,
      this.poids = 0,
      this.cuisses = 0,
      this.file,
      this.hanches = 0,
      this.poitrine = 0,
      this.taille = 0,
      this.ventre = 0,
      this.formState = AddMesureFormState.writing,
      this.url,
      });

  final DateTime date;
  final PickedFile file;
  final double poids;
  final double taille;
  final double ventre;
  final double hanches;
  final double cuisses;
  final double bras;
  final double poitrine;
  final AddMesureFormState formState;
  final String url;

  AddMesuresState copyWith({
    DateTime date,
    PickedFile file,
    double poids,
    double taille,
    double ventre,
    double hanches,
    double cuisses,
    double bras,
    double poitrine,
    AddMesureFormState formState,
  }) {
    return AddMesuresState(
      date: date ?? this.date,
      file: file ?? this.file,
      poids: poids ?? this.poids,
      taille: taille ?? this.taille,
      ventre: ventre ?? this.ventre,
      hanches: hanches ?? this.hanches,
      cuisses: cuisses ?? this.cuisses,
      bras: bras ?? this.bras,
      poitrine: poitrine ?? this.poitrine,
      formState:  formState ?? this.formState,
    );
  }

  @override
  List<Object> get props =>
      [date, file, poids, taille, ventre, hanches, cuisses, bras, poitrine,formState];
}
