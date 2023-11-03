
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

  Future<String> _uploadFile(String path) async{  // Subida de una imagen

    try {
      
      final fileName = path.split('/').last;                          // Nombre de la imagen desde el path.

      final FormData data = FormData.fromMap({                        // Data a subir al server que contiene el file.
        'file': MultipartFile.fromFileSync(path, filename: fileName)  
      });

      final response = await dio.post('/files/product', data:data);   // Subimos al backend la imagen.
      return response.data['image'];                                  // Respuesta del backend con la imagen renombrada.

    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadPhotos( List<String> photos ) async {   // Subida de las imagenes de la cámara o galería.

    final photosToUpload = photos.where((element) => element.contains('/')).toList(); // Imagenes de la cámara o galería.
    final photosToIgnore = photos.where((element) => !element.contains('/')).toList();// Imagenes que ya estaban.
  
    final List<Future<String>> uploadJob = photosToUpload.map( // Multiples subidas de fotos en forma de Future
      (e) => _uploadFile(e)
    ).toList();

    final newImages = await Future.wait(uploadJob); // Cuando terminan las subidas se ejecutan en una sola (wait())

    return[...photosToIgnore, ...newImages]; // Se devuelven las fotos que ya existían más las nuevas renombradas.
  }


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      
      final String? productId = productLike['id'];                                  // El id que nos ocupa es el del pto del formulario
      final String method = (productId == null) ? 'POST':'PATCH';                   // Sino viene es para crear, y si viene es para actualizar 
      final String url = (productId == null) ? '/products' :'/products/$productId'; // para crear la ruta no lleva id // para actualizar la ruta lleva el id del pto                    

      productLike.remove('id');                                                     // El backend no quiere que el id este presente
      productLike['images'] = await _uploadPhotos(productLike['images']);           // Subimos al backend las fotos de la cámara o galería

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