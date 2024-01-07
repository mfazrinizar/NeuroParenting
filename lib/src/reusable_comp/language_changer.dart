import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LanguageSwitcher extends StatelessWidget {
  final Function onPressed;
  final Color? textColor;

  const LanguageSwitcher({super.key, required this.onPressed, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Get.locale == const Locale('en', '')
              ? SvgPicture.asset(
                  'assets/icons/english_lang.svg',
                  width: 35,
                  fit: BoxFit.fill,
                )
              : Get.locale == const Locale('id', '')
                  ? SvgPicture.asset(
                      'assets/icons/indonesian_lang.svg',
                      width: 35,
                      fit: BoxFit.fill,
                    )
                  : SvgPicture.asset(
                      'assets/icons/english_lang.svg',
                      width: 35,
                      fit: BoxFit.fill,
                    ),
          onPressed: onPressed as void Function()?,
        ),
        if (textColor != null)
          Text(
            Get.locale == const Locale('en', '') ? 'EN' : 'ID',
            style: TextStyle(color: textColor),
          ),
        if (textColor == null)
          Text(
            Get.locale == const Locale('en', '') ? 'EN' : 'ID',
          ),
      ],
    );
  }
}
