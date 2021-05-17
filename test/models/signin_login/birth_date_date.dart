import 'package:appdiet/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('birth date', (){
    test('BirthDate KO',(){
      expect(BirthDate.dirty().validator(""),BirthDateValidationError.invalid);
    });

    test('BirthDate OK', (){
      expect(BirthDate.dirty().validator("17/05/2021"),null);
    });
  });
}