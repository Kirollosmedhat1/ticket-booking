import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontSize: ScreenSizeHandler.smaller * 0.0558,
          fontWeight: FontWeight.bold),
    );
  }
}
