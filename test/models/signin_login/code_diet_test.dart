import 'package:appdiet/data/models/signin_login/code_diet.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('code diet', (){
    test('Code diet NOK',(){
      expect(CodeDiet.dirty().validator('12Az'),CodeDietValidationError.invalid);
    });

    test('CodeDiet OK',(){
      expect(CodeDiet.dirty().validator('AZERTY'),null);
    });
  });
}