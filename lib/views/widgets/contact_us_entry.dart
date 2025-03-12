import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class ContactUsEntry extends StatelessWidget {
  const ContactUsEntry(
      {super.key,
      required this.text,
      required this.isUnderLined,
      required this.isNormal,
      required this.customIcon,
      required this.iconColor});

  final String text;
  final bool isUnderLined;
  final bool isNormal;
  final IconData customIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          !isNormal
              ? Icon(
                  customIcon,
                  color: iconColor,
                  size: ScreenSizeHandler.smaller * 0.058,
                )
              : Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: ScreenSizeHandler.smaller * 0.058,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: ScreenSizeHandler.smaller * 0.0326,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFFDFA000),
                  decoration: isUnderLined
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: const Color(0xFFDFA000),
                  decorationThickness: 2),
            ),
          )
        ],
      ),
    );
  }
}
