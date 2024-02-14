import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/homepage.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({Key? key}) : super(key: key);

  @override
  PaymentHistoryPageState createState() => PaymentHistoryPageState();
}

class PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(
            () => const HomePage(indexFromPrevious: 2),
          ),
        ),
      ),
      body: user != null
          ? FutureBuilder<QuerySnapshot>(
              future: _firestore
                  .collection('payment')
                  .where('customerDetails.userId', isEqualTo: user?.uid ?? "")
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('An error occurred: ${snapshot.error}'));
                }

                final paymentDocs = snapshot.data!.docs;

                if (paymentDocs.isEmpty) {
                  return const Center(
                      child: Text('You don\'t have any payment history.'));
                }

//        {
//         'isProduction': isProduction,
//         'transactionDetails': {
//           'orderId': orderId,
//           'grossAmount': priceTotal,
//           'dateAndTime': DateTime.now(),
//           'paymentType': paymentType,
//           'transactionStatus': transactionStatus,
//           'transactionId': transactionId,
//         },
//         'itemDetails': {
//           'id': itemId,
//           'category': category,
//           'price': priceTotal,
//           'quantity': 1,
//           'name': itemName,
//           'itemDescription': itemDescription,
//         },
//         'customerDetails': {
//           'email': email,
//           'firstName': firstName,
//           'lastName': lastName,
//           'name': name,
//           'userId': userId,
//         },
//       },

                return ListView.builder(
                  itemCount: paymentDocs.length,
                  itemBuilder: (context, index) {
                    final payment = paymentDocs[index];

                    return ListTile(
                      title: Text(payment['itemDetails']['name']),
                      subtitle: Text(
                          'Name: ${payment['customerDetails']['name']}\nEmail: ${payment['customerDetails']['email']}\nCategory: ${payment['itemDetails']['category']}\nTotal: IDR ${payment['itemDetails']['price']}\nDate & Time: ${payment['transactionDetails']['dateAndTime'].toDate()}\nVia: ${payment['transactionDetails']['paymentType']}\nOrder ID: ${payment['transactionDetails']['orderId']}\nTransaction ID: ${payment['transactionDetails']['transactionId']}\nDescription: ${payment['itemDetails']['itemDescription']}'),
                      // trailing: Text(
                      //     'Transaction Date: ${payment['transactionDetails']['dateAndTime'].toDate()}'),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text('Please sign in to view your payment history.'),
            ),
    );
  }
}
