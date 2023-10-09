

import '../entities/user.dart';

abstract class AuthDataSource {

  Future<User> login( String email, String password );
  Future<User> register( String email, String Password, String fullName );
  Future<User> checkAuthStatus( String token );
}