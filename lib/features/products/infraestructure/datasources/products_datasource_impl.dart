
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infraestructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infraestructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }  
    ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      
      final String productId = productLike['id'];                               // El id que nos ocupa es el del pto del formulario
      final String method = (productId == null) ? 'POST':'PATCH';               // Sino viene es para crear, y si viene es para actualizar 
      final String url = (productId == null) ? '/products' :'/products/$productId'; // para crear la ruta no lleva id // para actualizar la ruta lleva el id del pto                    

      productLike.remove('id');                                                 // El backend no quiere que el id este presente
   
      final response = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method
        )
      );

      final product = ProductMapper.jsonToEntity(response.data);

      return product;

    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async{
    try {
      
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;

    } on DioException catch(e){

      if( e.response!.statusCode == 404 ) throw ProductNotFound();
      throw Exception();

    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (var product in response.data ?? []){
      products.add( ProductMapper.jsonToEntity(product)); 
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }

}