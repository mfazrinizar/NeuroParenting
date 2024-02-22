import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDbAPI {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> postPayment({
    required bool isProduction,
    required String orderId,
    required int priceTotal,
    required String paymentType,
    required String transactionStatus,
    required String transactionId,
    required String itemId,
    required String category,
    required String itemName,
    required String itemDescription,
    required String email,
    required String firstName,
    required String lastName,
    required String userId,
    required String name,
  }) async {
    await _firestore.collection('payment').doc('$userId-:-$orderId').set(
      {
        'isProduction': isProduction,
        'transactionDetails': {
          'orderId': orderId,
          'grossAmount': priceTotal,
          'dateAndTime': DateTime.now(),
          'paymentType': paymentType,
          'transactionStatus': transactionStatus,
          'transactionId': transactionId,
        },
        'itemDetails': {
          'id': itemId,
          'category': category,
          'price': priceTotal,
          'quantity': 1,
          'name': itemName,
          'itemDescription': itemDescription,
        },
        'customerDetails': {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'name': name,
          'userId': userId,
        },
      },
    );
  }
}
