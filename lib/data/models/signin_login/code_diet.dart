import 'package:formz/formz.dart';

enum CodeDietValidationError { invalid }

class CodeDiet extends FormzInput<String, CodeDietValidationError> {
  const CodeDiet.pure() : super.pure('');
  const CodeDiet.dirty([String value = '']) : super.dirty(value);

  static final RegExp _codeDietRegExp = RegExp(
    r'^[A-Z0-9]{6}$',
  );

  @override
  CodeDietValidationError? validator(String value) {
    return _codeDietRegExp.hasMatch(value)
        ? null
        : CodeDietValidationError.invalid;
  }
}
