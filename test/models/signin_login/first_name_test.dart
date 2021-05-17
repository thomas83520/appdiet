import 'package:appdiet/data/models/signin_login/first_name.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('first name test', (){
    test('First name NOK', (){
      expect(FirstName.dirty().validator("&&ldmd"), FirstNameValidationError.invalid);
    });

    test('First name OK', (){
      expect(FirstName.dirty().validator("Arnoux"), null);
    });
  });
}