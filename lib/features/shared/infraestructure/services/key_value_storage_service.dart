
// Reglas (esquema de funcionamiento)

abstract class KeyValueStorageService {
  Future<void> setKeyValue<T>( String key, T value ); // T es un tipo genérico. Si se manda un int lo acepta, si se manda un string tambien etc
  Future<T?> getValue<T>( String key ); // si recibe un T string se espera que devuelva un T string?
  Future<bool> removeKey( String key ); // Devuelve un boolean
}