import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double defaultFontSize;

  const CustomText(this.data,
      {super.key, this.style, this.defaultFontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style?.copyWith(fontSize: defaultFontSize) ??
          TextStyle(fontSize: defaultFontSize),
    );
  }
}
