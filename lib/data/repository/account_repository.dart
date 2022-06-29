import 'package:appdiet/data/models/models.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AccountRepository {
  AccountRepository({required this.user})
      : _functions = FirebaseFunctions.instanceFor(region: 'europe-west1');

  final User user;
  final FirebaseFunctions _functions;
  Future<bool> deleteAccount() async {
    try {
      final result = await _functions
          .httpsCallable("deleteAccountUser")
          .call({"userId": user.id});
      return result.data;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
