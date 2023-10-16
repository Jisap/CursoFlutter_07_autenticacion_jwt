import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// 1º State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
      LoginFormState:
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        email: $email
        password: $password
    ''';
  }
}

// 2º notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {

  final Function(String, String)loginUserCallback; // Función del AuthProvider que devuelve un usuario logueado

  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail, 
      isValid: Formz.validate([newEmail, state.password])
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email])
    );
  }

  onFormSubmit() async {
    _touchEveryField();         // Se reciben los values de los campos y se cambia el estado del formulario

    if (!state.isValid) return; // Si el state es invalid return

    state = state.copyWith(     // Pero si es válido, isPosting=true
        isPosting: true
    );

    await loginUserCallback(    // Se hace login en authProvider con los valores del formulario
        state.email.value,
        state.password.value
    );

    state = state.copyWith(     // Hecho el posteo del login sea o no válido, isPosting = false
        isPosting: false
    );
  }

  _touchEveryField() {
    
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);

      state = state.copyWith(
          isFormPosted: true,
          email: email,
          password: password,
          isValid: Formz.validate([email, password]));
  }
}

// StateNotifierProvider - consume afuera
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser; // loginUserCallback esta referenciado al login del authprovider

  return LoginFormNotifier(loginUserCallback: loginUserCallback);       // Con el usuario logueado se cambia el estado del formulario
});
