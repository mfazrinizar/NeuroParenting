import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final Function onPressed;

  const ThemeSwitcher({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.brightness_4,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 211, 227, 253)
            : Colors.white,
        // Color.fromARGB(255, 211, 227, 253)
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
