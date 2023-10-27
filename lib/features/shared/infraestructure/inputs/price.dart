import 'package:formz/formz.dart';

enum PriceError { empty, value }                                    // Definimos los errores de validación de los inputs

class Price extends FormzInput<double, PriceError> {                // Extendemos la clase FormzInput para crear la clase de entrada personalizada
                                                                    // para el price. Esta clase proporciona funcionalidad básica para la validación

  const Price.pure() : super.pure(0.0);                             // Constructor que crea una nueva entrada 'Price' con un valor vacio.
  
  const Price.dirty(double value) : super.dirty(value);             // Constructor que crea una nueva entrada 'Price' con el valor dado.

  String? get errorMessage {                                        // Getter que devuelve el mensaje de error para el estado de validación actual.
    if (isValid || isPure) return null;
    if (displayError == PriceError.empty) return 'El campo es requerido';
    if (displayError == PriceError.value) return 'Tiene que ser un número mayor o igual a cero';
    return null;
  }

 
  @override                                                              // Validator es responsable de validar el price
  PriceError? validator(double value) {

    if (value.toString().isEmpty || value.toString().isEmpty) return PriceError.empty;  // Si el input esta vacio devuelve un PriceError.empty
    if (value < 0) return PriceError.value;                                             // Si el input del price es un valor negativo dará error
    return null;
  }
}
