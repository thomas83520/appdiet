import 'package:equatable/equatable.dart';

class Repas extends Equatable{
  const Repas({this.id,this.name, this.heure, this.before, this.satiete,this.contenu, this.commentaire});

  final String id;
  final String name;
  final String heure;
  final int before;
  final int satiete;
  final String contenu;
  final String commentaire;

  static const empty = Repas(id:'',name: '',heure: '',before: 5,satiete: 5,contenu : '',commentaire: '' );

  static List<Repas> fromSnapshot(List<dynamic> snapshot){
    print("list :" + snapshot.toString());
    return snapshot.map((snap) => Repas(
      id: snap["id"],
      name: snap["nom"],
      heure: snap["heure"],
      before: 0,
      satiete: 0,
      contenu: "",
      commentaire: "",
    )).toList();
  }

  Map<String,Object> toDocuments(){
    return {
      "id" : id,
      "name" : name,
      "heure" : heure,
      "before" : before,
      "satiete" : satiete,
      "contenu" : contenu,
      "commentaire" : commentaire,
    };
  } 
  
  @override
  List<Object> get props => [id,name,heure,before,satiete,contenu,commentaire];

}