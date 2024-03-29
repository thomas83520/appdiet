import 'dart:core';

import 'package:equatable/equatable.dart';

class PoidsMesures extends Equatable {
  const PoidsMesures({required this.mesures,required  this.poids,required this.photos});

  final Map<MesureType,List<Mesures>> mesures;
  final List<Poids> poids;
  final Map<DateTime,List<String>> photos;


  @override
  List<Object> get props => [mesures,poids,photos];
}

enum MesureType { taille,ventre,hanche,cuisses,bras, poitrine }

class Mesures extends Equatable {
  const Mesures({required this.date,required  this.mesure});

  final DateTime date;
  final double mesure;

  @override
  List<Object> get props => [date,mesure];
}

class Poids extends Equatable {
  const Poids({required this.poids,required this.date});

  final double poids;
  final DateTime date;

  @override
  List<Object> get props => [poids,date];
}
