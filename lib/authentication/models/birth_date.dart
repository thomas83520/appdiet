import 'package:formz/formz.dart';

enum BirthDateValidationError { invalid }

class BirthDate extends FormzInput<String, BirthDateValidationError> {
  const BirthDate.pure() : super.pure('');
  const BirthDate.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9]$',
  );

  @override
  BirthDateValidationError validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : BirthDateValidationError.invalid;
  }
}