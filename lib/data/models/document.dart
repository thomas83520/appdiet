import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Document extends Equatable {
  Document(
      {required this.name,
      required this.visibility,
      required this.date,
      required this.idPatient,
      required this.id,
      required this.downloadUrl,
      required this.extension});

  final String name;
  final String visibility;
  final String date;
  final String idPatient;
  final String id;
  final String downloadUrl;
  final String extension;

  static Document fromSnapshot(DocumentSnapshot snapshot) {
    var doc = Document(
      name: snapshot.get('name'),
      visibility: snapshot.get('visibilite'),
      date: DateFormat('yyyy-MM-dd')
          .format((snapshot.get('date') as Timestamp).toDate()),
      idPatient: snapshot.get('idPatient'),
      downloadUrl: snapshot.get('downloadUrl'),
      extension: snapshot.get('extension'),
      id: snapshot.id,
    );
    return doc;
  }

  @override
  List<Object> get props =>
      [name, visibility, date, idPatient, id, downloadUrl, extension];
}
