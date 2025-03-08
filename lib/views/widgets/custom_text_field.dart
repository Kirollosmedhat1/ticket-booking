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

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(
              fontSize:
                  screenWidth * 0.017, // 🔥 Dynamic error message font size
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: screenWidth * 0.017,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.blue, width: screenWidth * 0.003),
            ),
            errorMaxLines: 3,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon,
                    color: Colors.blueGrey, size: screenWidth * 0.06)
                : null,
          ),
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(fontSize: screenWidth * 0.017),
        ),
      ),
    );
  }
}
