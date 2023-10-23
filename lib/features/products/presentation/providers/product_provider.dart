



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

import '../../domain/domain.dart';



class ProductState {
  
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) => ProductState (
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving
  );
}

class ProductNotifier extends StateNotifier<ProductState>{ // Observable que almacena un state

  final ProductsRepository productsRepository;  // Métodos desde el domain

  ProductNotifier({
    required this.productsRepository,
    required String productId,
  }):super(ProductState(id: productId));

  Future<void> loadProduct() async {

  }

}

// Crea un [stateNotifier] y expone el state actual
              
final productProvider =                     //Métodos       //state       //id
  StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {
    
    final productsRepository = ref.watch(productsRepositoryProvider);  // Métodos que dependen de un token

    return ProductNotifier(                                            // Crea un state basado en esos métodos
      productsRepository: productsRepository, 
      productId: productId
    );
  });