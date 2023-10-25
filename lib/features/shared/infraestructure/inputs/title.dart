import 'package:formz/formz.dart';

enum TitleError { empty }                                           // Definimos los errores de validación de los inputs

class Title extends FormzInput<String, TitleError> {                // Extendemos la clase FormzInput para crear la clase de entrada personalizada
                                                                    // para el title. Esta clase proporciona funcionalidad básica para la validación

  const Title.pure() : super.pure('');                              // Constructor que crea una nueva entrada 'Title' con un valor vacio.
  
  const Title.dirty(String value) : super.dirty(value);             // Constructor que crea una nueva entrada 'Title' con el valor dado.

  String? get errorMessage {                                        // Getter que devuelve el mensaje de error para el estado de validación actual.
    if (isValid || isPure) return null;
    if (displayError == TitleError.empty) return 'El campo es requerido';

    return null;
  }

 
  @override                                                              // Validator es responsable de validar el email
  TitleError? validator(String value) {

    if (value.isEmpty || value.trim().isEmpty) return TitleError.empty;  // Si el input esta vacio devuelve un EmailError.empty
    
    return null;
  }
}
