import 'package:equatable/equatable.dart';

class DayComments extends Equatable{
  const DayComments({this.id,this.name, this.heure,this.contenu});

  final String id;
  final String name;
  final String heure;
  final String contenu;

  static const empty = DayComments(id:'',name: '',heure: '',contenu : '');

  static List<DayComments> fromSnapshot(List<dynamic> snapshot){
    print("list :" + snapshot.toString());
    return snapshot.map((snap) => DayComments(
      id: snap["id"],
      name: snap["nom"],
      heure: snap["heure"],
      contenu: "",
    )).toList();
  }

  Map<String,Object> toDocuments(){
    return {
      "id" : id,
      "name" : name,
      "heure" : heure,
      "contenu" : contenu,
    };
  } 
  
  @override
  List<Object> get props => [id,name,heure,contenu];

}