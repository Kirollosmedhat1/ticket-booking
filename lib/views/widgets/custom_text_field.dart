import 'dart:math';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define maximums
    double maxFontSize = 14;
    double maxErrorFontSize = 13;
    double maxIconSize = 22;
    double maxBorderRadius = 10; // Add max radius
    double maxBorderWidth = 2;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.02),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              errorStyle: TextStyle(
                fontSize: min(screenWidth * 0.033, maxErrorFontSize),
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "   $labelText",
                style: TextStyle(
                  fontSize: min(screenWidth * 0.033, maxFontSize),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      min(screenWidth * 0.02, maxBorderRadius),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: min(screenWidth * 0.004, maxBorderWidth),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      min(screenWidth * 0.02, maxBorderRadius),
                    ),
                    borderSide: BorderSide(
                      width: min(screenWidth * 0.004, maxBorderWidth),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      min(screenWidth * 0.02, maxBorderRadius),
                    ),
                    borderSide: BorderSide(
                        color: const Color(0xffDFA000),
                        width: min(screenWidth * 0.004, maxBorderWidth)),
                  ),
                  errorMaxLines: 3,
                  prefixIcon: prefixIcon != null
                      ? Icon(
                          prefixIcon,
                          color: Colors.white,
                          size: min(screenWidth * 0.06, maxIconSize),
                        )
                      : null,
                ),
                validator: validator,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: TextStyle(
                  fontSize: min(screenWidth * 0.033, maxFontSize),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
