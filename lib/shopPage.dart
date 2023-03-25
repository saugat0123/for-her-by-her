import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Sanitary pad',
      image: 'assets/product1.jpg',
      price: 180,
    ),
    Product(
      name: 'Tampons',
      image: 'assets/2.jpg',
      price: 280,
    ),
    Product(
      name: 'Cloth pads',
      image: 'assets/3.jpg',
      price: 380,
    ),
    Product(
      name: 'Pain killer',
      image: 'assets/4.jpg',
      price: 40,
    ),
    Product(
      name: 'Hand wash',
      image: 'assets/5.jpg',
      price: 200,
    ),
    Product(
      name: 'Panty liners',
      image: 'assets/6.jpg',
      price: 120,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          new SizedBox(
            height: 100.0,
            width: 80.0,
            child: new IconButton(
                icon: Image.asset('assets/logo.png'), onPressed: () => {}),
          ),
        ],
        title: Text('Shop', style: TextStyle(fontFamily: 'Allura', fontSize: 30)),
        backgroundColor: Colors.pink[900],
        centerTitle: true,
        elevation: 5.0,
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
          Text('\Rs. ${product.price}'),
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
