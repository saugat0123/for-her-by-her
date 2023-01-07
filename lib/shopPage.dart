import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Product 1',
      image: 'assets/product1.jpg',
      price: 29.99,
    ),
    Product(
      name: 'Product 2',
      image: 'assets/product1.jpg',
      price: 39.99,
    ),
    Product(
      name: 'Product 3',
      image: 'assets/product1.jpg',
      price: 49.99,
    ),
    Product(
      name: 'Product 4',
      image: 'assets/product1.jpg',
      price: 59.99,
    ),
    Product(
      name: 'Product 5',
      image: 'assets/product1.jpg',
      price: 69.99,
    ),
    Product(
      name: 'Product 6',
      image: 'assets/product1.jpg',
      price: 79.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(products.length, (index) {
          return ProductCard(
            key: Key(products[index].name),
            product: products[index],
          );
        }),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required Key key, required this.product}) : super(key: key);

  _addProductToCart(BuildContext context) {
    FirebaseFirestore.instance.collection('cart').add({
      'name': product.name,
      'image': product.image,
      'price': product.price,
    });
    Fluttertoast.showToast(
      msg: 'Product added to cart',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(product.image),
          Text(product.name),
          Text('\$${product.price}'),
          TextButton(
            onPressed: () => _addProductToCart(context),
            child: Text('Buy'),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String image;
  final double price;

  const Product({required this.name, required this.image, required this.price});
}
