import 'package:appdiet/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Confirm password', (){
    test('Confirm password NOK', (){
      expect(ConfirmedPassword.dirty(password: "Test1234").validator("TEST1234"),ConfirmedPasswordValidationError.invalid);
    });

    test('Confirm password OK',(){
      expect(ConfirmedPassword.dirty(password: "Test1234").validator("Test1234"),null);
    });
  });
}