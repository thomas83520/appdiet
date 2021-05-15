import 'package:equatable/equatable.dart';

class DetailPhoto extends Equatable{
  final String photoUrl;
  final double poids;
  final Map<String, double> mesures;
  final DateTime date;

  DetailPhoto({this.photoUrl, this.poids, this.mesures, this.date});

  @override
  List<Object> get props => [photoUrl,poids,mesures,date];
}
