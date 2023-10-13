import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infraestructure/infrastructure.dart';
import '../../domain/datasources/auth_datasource.dart';


class AuthDataSourceImpl extends AuthDataSource { // Contiene la lógica para efectuar el login/register y el checkAuthStatus

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status', // Petición al backend de autenticación del usuario enviandole el token del login
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );

      final user = UserMapper.userJsonToEntity( response.data );
      return user;

    } on DioException catch (e) {

      if(e.response?.statusCode == 401){
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async { // Obtiene un user de la bd en base a las credenciales
    
    try {
      final response = await dio.post('/auth/login', data: {  // apiUrl + /auth/login
        'email': email,
        'password': password
      }); 

      final user = UserMapper.userJsonToEntity(response.data);

      return user;

    } on DioException catch (e){
        if(e.response?.statusCode == 401) throw WrongCredentials();
        if(e.type == DioExceptionType.connectionTimeout) throw ConnecctionTimeout();
        throw CustomError('Something wrong happend');
    } catch (e) {
      throw CustomError('Something wrong happend');
    }
    
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }

}