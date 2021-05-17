import 'package:appdiet/data/models/signin_login/email.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Email', (){

    test('Email KO', (){
      expect(Email.dirty().validator('salut'), EmailValidationError.invalid);
    });

    test('Email OK', (){
      expect(Email.dirty().validator('test@test.com'),null);
    });
  });
}