

import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String Password, String fullName);
  Future<User> checkAuthStatus(String token);
}
