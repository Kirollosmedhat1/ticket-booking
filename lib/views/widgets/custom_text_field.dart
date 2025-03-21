import 'dart:math';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool showEyeIcon; // Add this parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.showEyeIcon = false, // Default to false
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true; // Track whether the text is obscured

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double maxFontSize = 14;
    double maxErrorFontSize = 13;
    double maxIconSize = 20;
    double maxBorderRadius = 8;
    double maxBorderWidth = 2;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.01), // Reduced margin
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              errorStyle: TextStyle(
                fontSize: min(screenWidth * 0.030, maxErrorFontSize),
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "   $widget.labelText",
                style: TextStyle(
                  fontSize: min(screenWidth * 0.030, maxFontSize),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4), // Smaller gap between label and field
              TextFormField(
                cursorColor: Color(0xffDFA000),
                controller: widget.controller,
                obscureText: widget.obscureText && _isObscured, // Toggle obscure text
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.015, // Reduced vertical padding
                    horizontal: screenWidth * 0.025,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      min(screenWidth * 0.018, maxBorderRadius),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: min(screenWidth * 0.004, maxBorderWidth),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      min(screenWidth * 0.018, maxBorderRadius),
                    ),
                    borderSide: BorderSide(
                      width: min(screenWidth * 0.004, maxBorderWidth),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      min(screenWidth * 0.018, maxBorderRadius),
                    ),
                    borderSide: BorderSide(
                        color: const Color(0xffDFA000),
                        width: min(screenWidth * 0.004, maxBorderWidth)),
                  ),
                  errorMaxLines: 2,
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: Colors.white,
                          size: min(screenWidth * 0.05, maxIconSize),
                        )
                      : null,
                  suffixIcon: widget.showEyeIcon && widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _isObscured ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                            size: min(screenWidth * 0.05, maxIconSize),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured; // Toggle obscure state
                            });
                          },
                        )
                      : null,
                ),
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                style: TextStyle(
                  fontSize: min(screenWidth * 0.030, maxFontSize),
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