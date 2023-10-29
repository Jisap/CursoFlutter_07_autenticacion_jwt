
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'products_repository_provider.dart';

class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false, 
    this.limit = 10, 
    this.offset = 0, 
    this.isLoading = false, 
    this.products = const[],
  });


  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );
}

class ProductsNotifier extends StateNotifier<ProductsState> { // Observable que almacena un state
  
  final ProductsRepository productsRepository; // Métodos desde el domain
  
  ProductsNotifier({
    required this.productsRepository  // Constructor recibe el método,
  }): super( ProductsState() ) {      // y crea la primera instancia de ProductsState.
    loadNextPage();                   // Nada mas se crea la instancia del productsNotifier se llama al método.
  }       

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {

    try {
      final product = await productsRepository.createUpdateProduct(productLike);        // Pto del form
      final isProductInList = state.products.any((element) => element.id == product.id);  // Averiguamos si el pto estaba en el state
    
      if(!isProductInList){                               // Si no estaba en el state -> pto nuevo
        state = state.copyWith(                           // Añadimos el pto al state
          products: [...state.products, product]
        );
        return true;
      }

      state = state.copyWith(                                             // Si si está en el state -> actualizamos el pto 
        products: state.products.map(                                     // Buscamos en el state un elementID = ptoID a actualizar
          (element) => (element.id == product.id) ? product : element,
        ).toList()
      );
      return true;
    
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {

    if( state.isLoading || state.isLastPage ) return;

    state = state.copyWith(
      isLoading: true
    );

    final products = await productsRepository // Obtenemos los productos del backend
      .getProductsByPage(
        limit: state.limit,
        offset: state.offset,
      );

      if( products.isEmpty) {   // Si no hay productos -> dejamos de cargar y llegamos a la última página
        state = state.copyWith(
          isLoading: false,
          isLastPage: true
        );
        return;  
      }

      state = state.copyWith(                             // Si si hay productos
        isLastPage: false,                                // no llegamos a la última página
        isLoading: false,                                 // dejamos de cargar
        offset: state.offset + 10,                        // establecemos el nuevo offset
        products: [...state.products, ...products]        // añadimos a los products que teniamos en el state los nuevos
      );
  }

}
                                                //métodos          //state
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) { // Crea un [stateNotifier] y expone el state actual
  
  final productsRepository = ref.watch( productsRepositoryProvider ); // Métodos que dependen de un token
  
  return ProductsNotifier(productsRepository: productsRepository); // Crea un state basado en esos métodos
});


