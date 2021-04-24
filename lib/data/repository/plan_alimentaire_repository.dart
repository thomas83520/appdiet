import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PlanAlimentaireRepository {
  PlanAlimentaireRepository({User user})
      : assert(user != null),
        _user = user;

  final User _user;

  Future<PDFDocument> loadDocument() async{
    String downloadURL = await firebase_storage.FirebaseStorage.instance
      .ref(_user.id+'/plan_alimentaire.pdf')
      .getDownloadURL();
      print(_user.id);
      print("download URL : " + downloadURL);

      return await PDFDocument.fromURL(
        downloadURL,
      );
  }
}
