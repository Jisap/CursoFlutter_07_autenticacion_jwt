





import '../../domain/domain.dart';
import '../infrastructure.dart';


class AuthRepositoryImpl extends AuthRepository{

  final AuthDataSource dataSource;  // El repositorio llama al dataSource (definido en domain)

  //constructor
  AuthRepositoryImpl(
    AuthDataSource? dataSource                          // Si existe el dataSource lo uso
  ) : dataSource = dataSource ?? AuthDataSourceImpl();  // sino creo una nueva instancia  

  


  @override
  Future<User> checkAuthStatus(String token) {
     return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String Password, String fullName) {
    return dataSource.register(email, Password, fullName);
  }

}