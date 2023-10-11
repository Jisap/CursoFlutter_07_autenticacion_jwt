



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infrastructure.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

//state
class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage
  );

}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> { // Es una observable class que almacena un single immutable [state].

  final AuthRepository authRepository; // Entity (esquema de llamado a la lógica)

  AuthNotifier({
    required this.authRepository
  }): super( AuthState() );

  Future<void> loginUser( String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);

    } on WrongCredentials {
      logout('Credenciales no son correctas');
    } on ConnecctionTimeout{
      logout('Timeout');  
    } catch (e) {
      logout('Error no controlado');
    }

  }

  void registerUser( String email, String password) async {
  
  }

  void checkAuthStatus() async {
  
  }

  Future<void> logout([ String? errorMessage ]) async {
    //TODO limpiar token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }

  void _setLoggedUser( User user ){
    //TODO necesito guardar el token en el dispositivo.
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }
  
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) { // Expone el state a la app
  
  final authRepository = AuthRepositoryImpl(); // Llamado a la lógica (datasource_imp). Se usa el datasource que se estableció por defecto
  
  return AuthNotifier(authRepository: authRepository); //Instancia (esquema de llamado implementado con la lógica)
});