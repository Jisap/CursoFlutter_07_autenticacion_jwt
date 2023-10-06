import 'package:formz/formz.dart';

enum EmailError { empty, format }                                   // Definimos los errores de validación de los inputs

class Email extends FormzInput<String, EmailError> {                // Extendemos la clase FormzInput para crear la clase de entrada personalizada
                                                                    // para el email. Esta clase proporciona funcionalidad básica para la validación
  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',                            // Expresión regular que define como queremos el input del email.
  );

  const Email.pure() : super.pure('');                              // Constructor que crea una nueva entrada 'Email' con un valor vacio.
  
  const Email.dirty(String value) : super.dirty(value);             // Constructor que crea una nueva entrada 'Email' con el valor dado.

  String? get errorMessage {                                        // Getter que devuelve el mensaje de error para el estado de validación actual.
    if (isValid || isPure) return null;

    if (displayError == EmailError.empty) return 'El campo es requerido';
    if (displayError == EmailError.format)
      return 'No tiene formato de correo electrónico';

    return null;
  }

 
  @override                                                              // Validator es responsable de validar el email
  EmailError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return EmailError.empty;  // Si el input esta vacio devuelve un EmailError.empty
    if (!emailRegExp.hasMatch(value)) return EmailError.format;          // Si el input no satisface la expresión regular devuelve EmailError.format 

    return null;
  }
}
