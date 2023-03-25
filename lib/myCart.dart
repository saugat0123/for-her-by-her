// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';
//
// class MyCart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           new SizedBox(
//             height: 100.0,
//             width: 80.0,
//             child: new IconButton(
//                 icon: Image.asset('assets/logo.png'), onPressed: () => {}),
//           ),
//         ],
//         title: Text('My Cart', style: TextStyle(fontFamily: 'Allura', fontSize: 30)),
//         backgroundColor: Colors.pink[900],
//         centerTitle: true,
//         elevation: 5.0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('cart').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 if ((snapshot.data! as QuerySnapshot).docs.length == 0) {
//                   return Center(
//                     child: Text('Your cart is empty'),
//                   );
//                 }
//
//                 return ListView.builder(
//                   itemCount: (snapshot.data! as QuerySnapshot).docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot document = (snapshot.data! as QuerySnapshot).docs[index];
//                     return ListTile(
//                       title: Text(document['name']),
//                       subtitle: Text('\$${document['price']}'),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           document.reference.delete();
//                           Fluttertoast.showToast(
//                             msg: 'Product deleted from cart',
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: Colors.green,
//                             textColor: Colors.white,
//                             fontSize: 16.0,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('cart').snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Container();
//               }
//
//               double totalPrice = 0;
//               (snapshot.data! as QuerySnapshot).docs.forEach((document) {
//                 totalPrice += document['price'];
//               });
//
//               return Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 30),
//                 // child: Text('Total: \$$totalPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                 child: Column(
//                   children: <Widget>[
//                     Text('Total: \$$totalPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                     ElevatedButton(
//                         onPressed: () {
//                           payWithKhaltiInApp();
//                         },
//                         child: const Text("Pay with Khalti")),
//                     // Text(referenceId)
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   payWithKhaltiInApp() {
//     KhaltiScope.of(context).pay(
//       config: PaymentConfig(
//         amount: 1000, //in paisa
//         productIdentity: 'Product Id',
//         productName: 'Product Name',
//         mobileReadOnly: false,
//       ),
//       preferences: [
//         PaymentPreference.khalti,
//
//       ],
//       onSuccess: onSuccess,
//       onFailure: onFailure,
//       onCancel: onCancel,
//     );
//   }
//
//   void onSuccess(PaymentSuccessModel success) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Payment Successful'),
//
//           actions: [
//             SimpleDialogOption(
//                 child: const Text('OK'),
//                 onPressed: () {
//                   setState(() {
//                     referenceId = success.idx;
//                   });
//
//                   Navigator.pop(context);
//                 })
//           ],
//         );
//       },
//     );
//   }
//
//   void onFailure(PaymentFailureModel failure) {
//     debugPrint(
//       failure.toString(),
//     );
//   }
//
//   void onCancel() {
//     debugPrint('Cancelled');
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  String referenceId = "";
  int amt = 0;

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
        title: Text(
            'My Cart', style: TextStyle(fontFamily: 'Allura', fontSize: 30)),
        backgroundColor: Colors.pink[900],
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                    DocumentSnapshot document = (snapshot
                        .data! as QuerySnapshot).docs[index];
                    return ListTile(
                      title: Text(document['name']),
                      subtitle: Text('\$${document['price']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          document.reference.delete();
                          Fluttertoast.showToast(
                            msg: 'Product deleted from cart',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('cart').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              double totalPrice = 0;
              (snapshot.data! as QuerySnapshot).docs.forEach((document) {
                totalPrice += document['price'];
                amt = totalPrice.toInt();
              });

              return Padding(
                padding: const EdgeInsets.only(
                    left: 10, top: 0, right: 10, bottom: 30),
                // child: Text('Total: \$$totalPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                child: Column(
                  children: <Widget>[
                    Text('Total: \$$totalPrice', style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                    ElevatedButton(
                        onPressed: () {
                          payWithKhaltiInApp();
                        },
                        child: const Text("Pay with Khalti")),
                    // Text(referenceId)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: amt*100, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,

      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),

          actions: [
            SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    referenceId = success.idx;
                  });

                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
  }
}
