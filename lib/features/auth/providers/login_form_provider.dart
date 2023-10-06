import 'package:teslo_shop/features/shared/shared.dart';



// 1º State del provider
class LoginFormState{

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password
  );

  @override
  String toString(){

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

// Como implementamos un notifier


// StateNotifierProvider - consume afuera