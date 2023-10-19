

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infraestructure/infraestructure.dart';

// Provider read Only
final productsRepositoryProvider = Provider<ProductsRepository>((ref) { // expone a la app los métodos definidos en el  domain

  final accessToken = ref.watch( authProvider ).user?.token ?? ''; // Necesitamos el token que viene del provider de auth
 
  final productsRepository = ProductsRepositoryImpl( ProductsDatasourceImpl(accessToken: accessToken)); // Los métodos se basan en un datasource

  return productsRepository ;
});