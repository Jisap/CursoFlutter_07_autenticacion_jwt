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

}

// Como implementamos un notifier


// StateNotifierProvider - consume afuera