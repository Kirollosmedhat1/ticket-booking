import 'dart:math';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color textcolor;
  final Color bordercolor;
  final Color backgroundcolor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    required this.textcolor,
    required this.bordercolor,
    required this.backgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 50,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(screenWidth * 1, screenWidth * 0.13),
          backgroundColor: backgroundcolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.4),
              side: BorderSide(
                color: bordercolor,
                width:
                    min(screenWidth * 0.005, 2.0), // Set a maximum width of 2.0
              )),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.blueGrey)
            : Text(
                text,
                style: TextStyle(
                  color: textcolor,
                  fontSize: min(screenWidth * 0.043, 24), // Max 18 px font size
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
