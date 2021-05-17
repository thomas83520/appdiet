import 'package:appdiet/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Verify password validation', (){
    test('password validation KO', (){
      expect(Password.dirty("test").validator("test"), PasswordValidationError.invalid);
    });

    test('Password validation OK', (){
      expect(Password.dirty().validator("Test1234"), null);
    });
  });
}