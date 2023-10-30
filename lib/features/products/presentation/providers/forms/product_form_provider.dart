

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

import '../../../../shared/infraestructure/inputs/inputs.dart';
import '../../../domain/domain.dart';

class ProductFormState {

  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''), 
    this.price = const Price.dirty(0), 
    this.sizes = const [], 
    this.gender = 'men', 
    this.inStock = const Stock.dirty(0), 
    this.description = '', 
    this.tags = '', 
    this.images = const[]
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images
  );
}

//Mantiene la data y la procesa, ademas emite la data que será procesada por otros entes.

class ProductFormNotifier extends StateNotifier<ProductFormState> { // An observable class that stores a single immutable [state].

  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback; // Función que llama al provider y crea o actualiza el state
                                                                           // Devuele un bool que indica si el posteo se realizo correctamente
  ProductFormNotifier({
    this.onSubmitCallback,                                                 // Constructor recibe el método,
    required Product product,                                              // y el producto que se quiere actualizar, sino valores por defecto
  }):super(
    ProductFormState(                                                      // y crea la primera instancia de ProductFormState y con ella la del ProductNotifier
      id: product.id,                                                       
      title: Title.dirty(product.title),                                     
      slug: Slug.dirty(product.slug),
      price: Price.dirty(product.price),
      sizes: product.sizes,
      inStock: Stock.dirty(product.stock),
      gender: product.gender,
      description: product.description,
      tags: product.tags.join(', '),
      images: product.images,
    )
  );

  Future<bool>onFormSubmit() async {
    _touchedEverything();
    
    if(!state.isFormValid) return false;

    if(onSubmitCallback == null) return false;

    final productLike = { // Recibe los values de los inputs
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map((image) => image.replaceAll('${Environment.apiUrl}/files/product/', '')).toList()
    };

    try {
      
      return await onSubmitCallback!(productLike); // onSubmitCallback -> createUpdateCallback -> actualiza la bd

    } catch (e) {

      return false;
    }
  }

  void _touchedEverything(){              // Comprobación de la validación de los inputs del formulario (Formz)
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)
      ])
    );
  }

  void onTitleChanged( String value ){
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)   
      ])
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onStockChanged(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value)
        ]));
  }

  void onSizeChanged(List<String> sizes){
    state = state.copyWith(
      sizes: sizes
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags
    );
  }

}

// Crea un [stateNotifier] y expone el state actual                     //Métodos           //state        //producto
final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>(
  (ref, product)  {

   // Crea o actualiza el backend y también el state basado en el productsProvider
    final createUpdateCallback = ref.watch(productsProvider.notifier).createOrUpdateProduct;

    return ProductFormNotifier(                 // Se expone
      product: product,                         // el nuevo o actualizado pto (state)
      onSubmitCallback: createUpdateCallback,   // y el método que permite modificarlo.
    );
  }
);