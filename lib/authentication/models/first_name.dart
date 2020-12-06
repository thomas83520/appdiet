import 'package:formz/formz.dart';

enum FirstNameValidationError { invalid }

class FirstName extends FormzInput<String, FirstNameValidationError> {
  const FirstName.pure() : super.pure('');
  const FirstName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _firstNameRegExp = RegExp(
    r'^[a-zA-Z0-9]{1,40}$',
  );

  @override
  FirstNameValidationError validator(String value) {
    return _firstNameRegExp.hasMatch(value) ? null : FirstNameValidationError.invalid;
  }
}