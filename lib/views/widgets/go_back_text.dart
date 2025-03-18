import 'package:flutter/material.dart';

class GoBackText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GoBackText({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xffdfa000),
          decoration: TextDecoration.underline,
          decorationColor: Color(0xffdfa000),
        ),
      ),
    );
  }
}