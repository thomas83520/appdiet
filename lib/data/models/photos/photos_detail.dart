import 'package:equatable/equatable.dart';

class DetailPhoto extends Equatable {
  final String photoUrl;
  final double poids;
  final Map<String, double> mesures;
  final DateTime date;
  final String photoName;

  DetailPhoto(
      {required this.photoUrl,
      required this.poids,
      required this.mesures,
      required this.date,
      required this.photoName});

  @override
  List<Object> get props => [photoUrl, poids, mesures, date,photoName];
}
