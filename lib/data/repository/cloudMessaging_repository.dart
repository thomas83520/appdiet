import 'package:appdiet/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudMessagingRepository {
  Future<void> saveTokenToDataBase(User user, String token) async {
    print(user.id);
    await FirebaseFirestore.instance.collection('patient').doc(user.id).update({
      'token': FieldValue.arrayUnion([token])
    });
  }
}
