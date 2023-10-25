import 'package:formz/formz.dart';

enum SlugError { empty, format }                                   // Definimos los errores de validación de los inputs

class Slug extends FormzInput<String, SlugError> {                 // Extendemos la clase FormzInput para crear la clase de entrada personalizada
                                                                   // para el slug. Esta clase proporciona funcionalidad básica para la validación

  const Slug.pure() : super.pure('');                              // Constructor que crea una nueva entrada 'Slug' con un valor vacio.
  
  const Slug.dirty(String value) : super.dirty(value);             // Constructor que crea una nueva entrada 'Slug' con el valor dado.

  String? get errorMessage {                                       // Getter que devuelve el mensaje de error para el estado de validación actual.
    if (isValid || isPure) return null;
    if (displayError == SlugError.empty) return 'El campo es requerido';
    if (displayError == SlugError.format) return ' El campo no tiene el formato esperado';

    return null;
  }

 
  @override                                                              // Validator es responsable de validar el slug
  SlugError? validator(String value) {

    if (value.isEmpty || value.trim().isEmpty) return SlugError.empty;        // Si el input esta vacio devuelve un SlugError.empty
    if (value.contains("'") || value.contains(' ')) return SlugError.format;  // Si el input contiene ' o espacios devuelve un SlugError
    return null;
  }
}
