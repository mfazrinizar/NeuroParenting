import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingContent extends StatelessWidget {
  final String title, description, imageLight, imageDark;
  final bool isSvg;

  const OnboardingContent({
    Key? key,
    required this.title,
    required this.description,
    required this.imageLight,
    required this.imageDark,
    required this.isSvg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final image = isSvg
        ? SvgPicture.asset(
            isDarkMode ? imageDark : imageLight,
            height: MediaQuery.of(context).size.height * 0.50,
            fit: BoxFit.scaleDown,
          )
        : Image.asset(
            isDarkMode ? imageDark : imageLight,
            height: MediaQuery.of(context).size.height * 0.50,
            fit: BoxFit.cover,
          );

    return Column(
      children: <Widget>[
        image,
        const SizedBox(height: 25),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
