import 'package:appdiet/data/models/signin_login/name.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('name',(){
    test('Name validator NOK',(){
      expect(Name.dirty().validator("&AAAdre"), NameValidationError.invalid);
    });

    test('Name Validator OK',(){
      expect(Name.dirty().validator("Thomas"), null);
    });
  });
}