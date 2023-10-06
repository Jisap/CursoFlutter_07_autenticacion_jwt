import 'package:formz/formz.dart';


enum PasswordError { empty, length, format }                    // Define input validation errors


class Password extends FormzInput<String, PasswordError> {      // Extend FormzInput and provide the input type and error type.
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  const Password.pure() : super.pure('');                         // Call super.pure to represent an unmodified form input.

  const Password.dirty(String value) : super.dirty(value);        // Call super.dirty to represent a modified form input.

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordError.empty) return 'El campo es requerido';
    if (displayError == PasswordError.length) return 'Mínimo 6 caracteres';
    if (displayError == PasswordError.format)
      return 'Debe de tener Mayúscula, letras y un número';

    return null;
  }

 
  @override                                                         // Override validator to handle validating a given input value.
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 6) return PasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordError.format;

    return null;
  }
}
