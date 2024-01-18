import 'package:flutter/material.dart';

Widget customContainer(Widget child) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white
    ),
    child: child,
  );
}
