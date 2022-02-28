import 'package:appdiet/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentsRepository {
  DocumentsRepository({required this.user})
      : _firebaseFirestore = FirebaseFirestore.instance;

  final User user;
  final FirebaseFirestore _firebaseFirestore;

  Future<List<Document>> loadData(String type) async {
    var docDiet = await _firebaseFirestore
        .collection('dieteticien')
        .where('uidDiet', isEqualTo: user.uidDiet)
        .get();
    String idDiet = docDiet.docs.first.id;
    if (type == "partage") {
      var listDocPatient = await _firebaseFirestore
          .collection('dieteticien')
          .doc(idDiet)
          .collection('documents')
          .where('visibilite', isEqualTo: type)
          .get();
      return listDocPatient.docs.map((element) {
        return Document.fromSnapshot(element);
      }).toList();
    } else {
      var listDocPatient = await _firebaseFirestore
          .collection('dieteticien')
          .doc(idDiet)
          .collection('documents')
          .where('visibilite', isEqualTo: type)
          .where('patientId',isEqualTo: user.id)
          .get();
      return listDocPatient.docs.map((element) {
        return Document.fromSnapshot(element);
      }).toList();
    }
  }
}
