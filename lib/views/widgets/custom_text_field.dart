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
      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(
              fontSize: screenWidth * 0.033,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "   $labelText",
              style: TextStyle(
                fontSize: screenWidth * 0.033,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: screenWidth * 0.004,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(
                    width: screenWidth * 0.004,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xffDFA000), width: screenWidth * 0.004),
                ),
                errorMaxLines: 3,
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon,
                        color: Colors.white, size: screenWidth * 0.06)
                    : null,
              ),
              validator: validator,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: TextStyle(
                fontSize: screenWidth * 0.033,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
