import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  final String name;

  const WelcomeText({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, $name 👋",
          style: TextStyle(fontSize: ScreenSizeHandler.smaller*0.04186, color: Color(0xFFF2F2F2)),
        ),
        Text(
          "Welcome",
          style: TextStyle(
              fontSize: ScreenSizeHandler.smaller*0.06,
              color: const Color(0xFFDFA000),
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}