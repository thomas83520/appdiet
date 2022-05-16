import 'dart:core';

import 'package:equatable/equatable.dart';

class PoidsMesures extends Equatable {
  const PoidsMesures({required this.mesures,required  this.poids});

  final Map<MesureType,List<Mesures>> mesures;
  final List<Poids> poids;


  @override
  List<Object> get props => [mesures,poids];
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
