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
    this.isLoading = false, required this.textcolor, required this.bordercolor, required this.backgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 1,
      height: screenWidth * 0.13,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.4),
            side: BorderSide(
              color: bordercolor,
              width: screenWidth * 0.005
            )
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.blueGrey)
            : Text(
                text,
                style: TextStyle(
                    color: textcolor,
                    fontSize: screenWidth * 0.043,
                    fontWeight: FontWeight.w900),
              ),
      ),
    );
  }
}
