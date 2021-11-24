import 'package:appdiet/data/models/journal/Day_comments.dart';
import 'package:appdiet/data/models/journal/repas.dart';
import 'package:appdiet/data/models/journal/wellbeing.dart';
import 'package:equatable/equatable.dart';

class Journal extends Equatable {
  const Journal(
      {required this.mapCommentaires,
      required this.mapRepas,
      required this.wellBeing,
      required this.date});

  final List<Repas> mapRepas;
  final List<DayComments> mapCommentaires;
  final WellBeing wellBeing;
  final String date;

  static const empty = Journal(
      mapRepas: [],
      mapCommentaires: [],
      wellBeing: WellBeing.empty,
      date: 'idk');

  @override
  List<Object> get props => [mapRepas, mapCommentaires, wellBeing, date];
}
