import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import '../../domain/domain.dart';


class ProductScreen extends ConsumerWidget {  // A [StatelessWidget] that can listen to providers.

  final String productId; // Recibimos el id del pto

  const ProductScreen({
    super.key,
    required this.productId,
  });

  void showSnackbar ( BuildContext context ){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto Actualizado'))
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId)); // Obtenemos el state del pto desde el id

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar producto'),
          actions: [
            IconButton(
                onPressed: () async {
                  final photoPath = await CameraGalleryServiceImpl().selectPhoto(); // Seleccionamos la foto
                  if( photoPath == null ) return;                                   // Si es null return
                  ref.read(productFormProvider(productState.product!).notifier).updateProductImage(photoPath); // Actualizamos el state de images
                  photoPath;
                }, 
                icon: const Icon(Icons.photo_library_outlined)
            ),
            IconButton(
                onPressed: () async{
                  final photoPath = await CameraGalleryServiceImpl().takePhoto();
                  if( photoPath == null ) return;
                  ref.read(productFormProvider(productState.product!).notifier).updateProductImage(photoPath);
                  photoPath;
                },
                icon: const Icon(Icons.camera_alt_outlined)
            ),
          ],
        ),
        body: productState.isLoading
            ? const FullScreenLoader()
            : _ProductView(
                product: productState.product!) // Enviamos el pto a la vista
        ,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          if (productState.product == null) return;
          
          ref.read(productFormProvider(productState.product!).notifier)
            .onFormSubmit() // Se actualiza el state y la bd desde el productFormProvider, // basado a su vez este en el productsProvider
              .then((value) {
                if(!value) return;
                showSnackbar(context);
              });
          },                                                                            
          child: const Icon(Icons.save_as_outlined)
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  
  final Product product; // La vista recibe el pto

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product)); // Se muestra en los inputs los values del producto que se quiere actualizar

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productForm.images),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(
              productForm.title.value, 
              style: textStyles.titleSmall,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));      // Establecemos el state del form a partir del pto

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),

          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onTitleChanged(value),                               // Método del FormProvide para cambiar su valor
            errorMessage: productForm.title.errorMessage,
          ),

          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onSlugChanged(value),                                // idem
            errorMessage: productForm.slug.errorMessage,
          ),

          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product).notifier).onPriceChanged(double.tryParse(value) ?? -1), // idem
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,                                              // Viene del state del form y sino valor por defecto
            onSizesChanged: ref.read(productFormProvider(product).notifier).onSizeChanged, // Viene de los métodos del provider
          ),
          const SizedBox(height: 5),

          _GenderSelector(
            selectedGender: productForm.gender,                                               // Viene del state del form y sino valor por defecto
            onGenderChanged: ref.read(productFormProvider(product).notifier).onGenderChanged, // Viene de los meétodos del provider
          ),
          const SizedBox(height: 15),

          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onStockChanged(int.tryParse(value) ?? -1), // idem
            errorMessage: productForm.inStock.errorMessage,
          ),

          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: ref.read(productFormProvider(product).notifier).onDescriptionChanged,
          ),

          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged: ref.read(productFormProvider(product).notifier).onTagsChanged,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String>selectedSizes;                                        // Definimos los tamaños seleccionados List<String>
  final List<String> sizes = const ['XS','S','M','L','XL','XXL','XXXL'];  // Definimos los tamaños que hay

  final void Function(List<String> selectedSizes) onSizesChanged;         // Definimos la función del provider que cambia el state

  const _SizeSelector({
    required this.selectedSizes, 
    required this.onSizesChanged
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {                                        // Un boton por cada tamaño
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(),
      selected: Set.from(selectedSizes),                                  // Indica cual fue pulsado
      onSelectionChanged: (newSelection) {            // Cuando se pulsa una opción -> método del formProvider -> cambia el state
        onSizesChanged(List.from(newSelection));
        FocusScope.of(context).unfocus();
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;                                  // Definimos el género seleccionado
  final List<String> genders = const ['men', 'women', 'kid'];   // Definimos los generos que hay
  final void Function(String selectedGender) onGenderChanged;   // Definimos la función del provider que cambia el state
  final List<IconData> genderIcons = const [Icons.man, Icons.woman, Icons.boy,];


  const _GenderSelector({
    required this.selectedGender,
    required this.onGenderChanged
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {            
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onGenderChanged(newSelection.first);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    if( images.isEmpty){  // Si la images[] esta vacio se muestra no-images.jpg
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover
        )
      );
    }

    return PageView(                                                   // Si la images[] tiene contenido
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children:
        images.map((image) {                                           // mapeo 

          late ImageProvider imageProvider;
          if(image.startsWith('http')){                                // Si la image tiene http usamos NetworkImage
            imageProvider = NetworkImage(image);
          }else{
            imageProvider = FileImage(File(image));                    // Sino significara que viene de la gallery o la camara 
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage(
                fit: BoxFit.cover,
                image: imageProvider,   // Aquí se usa la imagen 
                placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              )
            ),
          );

        }).toList(),
    );
  }
}
