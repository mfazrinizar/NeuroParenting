import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomExpansionTile extends StatefulWidget {
  final DocumentSnapshot payment;

  const CustomExpansionTile({super.key, required this.payment});

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: RotationTransition(
        turns: animationController,
        child: Icon(
          Icons.expand_more,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      onExpansionChanged: (bool expanded) {
        if (expanded) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      },
      title: Text(widget.payment['itemDetails']['name']),
      subtitle: Text(
          'Total: IDR ${widget.payment['itemDetails']['price']}\nVia: ${widget.payment['transactionDetails']['paymentType']}'),
      children: <Widget>[
        ListTile(
          title: Text(
            'Name: ${widget.payment['customerDetails']['name']}\nEmail: ${widget.payment['customerDetails']['email']}\nCategory: ${widget.payment['itemDetails']['category']}\nDate: ${DateFormat('yyyy-MM-dd').format(widget.payment['transactionDetails']['dateAndTime'].toDate())}\nTime: ${DateFormat('HH:mm:ss').format(widget.payment['transactionDetails']['dateAndTime'].toDate())}\nOrder ID: ${widget.payment['transactionDetails']['orderId']}\nTransaction ID: ${widget.payment['transactionDetails']['transactionId']}\nDescription: ${widget.payment['itemDetails']['itemDescription']}',
            style: const TextStyle(fontSize: 14),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text:
                      '${widget.payment['itemDetails']['name']}\nTotal: IDR ${widget.payment['itemDetails']['price']}\nVia: ${widget.payment['transactionDetails']['paymentType']}\n\nName: ${widget.payment['customerDetails']['name']}\nEmail: ${widget.payment['customerDetails']['email']}\nCategory: ${widget.payment['itemDetails']['category']}\nDate: ${DateFormat('yyyy-MM-dd').format(widget.payment['transactionDetails']['dateAndTime'].toDate())}\nTime: ${DateFormat('HH:mm:ss').format(widget.payment['transactionDetails']['dateAndTime'].toDate())}\nOrder ID: ${widget.payment['transactionDetails']['orderId']}\nTransaction ID: ${widget.payment['transactionDetails']['transactionId']}\nDescription: ${widget.payment['itemDetails']['itemDescription']}',
                ),
              );
              Get.snackbar('Copied', 'Payment details successfully copied.');
            },
          ),
        ),
      ],
    );
  }
}
