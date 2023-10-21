import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';

class ProductScreen extends ConsumerStatefulWidget { // A [StatefulWidget] that can read providers.
  
  final String productId;
  
  const ProductScreen({
    super.key,
    required this.productId, 
  });

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends ConsumerState<ProductScreen> { // [state] tipo productScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto')
      ),
      body: Center(
        child: Text(widget.productId)
      )
    );
  }
}