import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if ((snapshot.data! as QuerySnapshot).docs.length == 0) {
            return Center(
              child: Text('Your cart is empty'),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = (snapshot.data! as QuerySnapshot).docs[index];
              return ListTile(
                title: Text(document['name']),
                subtitle: Text('\$${document['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}
