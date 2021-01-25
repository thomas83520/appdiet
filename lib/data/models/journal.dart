import 'package:appdiet/data/models/Day_comments.dart';
import 'package:appdiet/data/models/repas.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Journal extends Equatable {
  const Journal({ 
    @required this.mapCommentaires, 
    @required this.mapRepas,
    this.date
  });

  final List<Repas> mapRepas;
  final List<DayComments> mapCommentaires;
  final String date;

  static const empty = Journal(mapRepas:  [], mapCommentaires: [],date: 'idk');

   
  @override
  List<Object> get props => [mapRepas, mapCommentaires,date];
}
