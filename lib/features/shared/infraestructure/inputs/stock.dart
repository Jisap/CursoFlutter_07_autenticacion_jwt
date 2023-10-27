import 'package:formz/formz.dart';

enum StockError { empty, value, format }                         // Definimos los errores de validación de los inputs

class Stock extends FormzInput<int, StockError> {                // Extendemos la clase FormzInput para crear la clase de entrada personalizada
                                                                 // para el stock. Esta clase proporciona funcionalidad básica para la validación

  const Stock.pure() : super.pure(0);                            // Constructor que crea una nueva entrada 'Stock' con un valor vacio.
  
  const Stock.dirty(int value) : super.dirty(value);             // Constructor que crea una nueva entrada 'Stock' con el valor dado.

  String? get errorMessage {                                     // Getter que devuelve el mensaje de error para el estado de validación actual.
    if (isValid || isPure) return null;
    if (displayError == StockError.empty) return 'El campo es requerido';
    if (displayError == StockError.value) return 'Tiene que ser un número mayor o igual a cero';
    if (displayError == StockError.format) return 'No tiene formato de número';
    return null;
  }

 
  @override                                                              // Validator es responsable de validar el stock
  StockError? validator(int value) {

    if (value.toString().isEmpty || value.toString().isEmpty) return StockError.empty;  // Si el input esta vacio devuelve un StockError.empty
    
    final isInteger = int.tryParse(value.toString()) ?? -1;                             // Definimos un valor int para el value
    if( isInteger == -1 ) return StockError.format;                                     // Si no se convirtio devuelve StockError

    if (value < 0) return StockError.value;                                             // Si el input del Stock es un valor negativo dará error
    return null;
  }
}
