import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final Function onPressed;

  const ThemeSwitcher({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.brightness_4),
      onPressed: onPressed as void Function()?,
    );
  }
}
