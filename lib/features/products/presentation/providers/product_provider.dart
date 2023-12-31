



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
    required this.productsRepository,           // Constructor recibe el método,
    required String productId,                  // y el id del producto
  }):super(ProductState(id: productId)){        // y crea la primera instancia de ProductState.
    loadProduct();                              // Nada mas se crea la instancia del productNotifier se llama al método.
  }

  Product newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      slug: '',
      stock: 0,
      sizes: [],
      gender: 'men',
      tags: [],
      images: []
    );
  }

  Future<void> loadProduct() async {
    try {

      if(state.id == 'new'){            // Si existe un pto con el id new 
        
        state = state.copyWith(         // se crea un nuevo state 
          isLoading: false,             // con isLoadign en false
          product: newEmptyProduct()    // y las props del nuevo pto vacio
        );
        
        return; // y se termina sin la carga del pto aquí.
      }

      final product = await productsRepository.getProductById(state.id);
      state = state.copyWith(
        isLoading: false,
        product: product
      );
    } catch (e) {
      print(e);
    }
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