import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
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
          backgroundColor: Color(0xffDFA000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.4),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.blueGrey)
            : Text(
                text,
                style: TextStyle(color: Colors.black, fontSize:  screenWidth * 0.043,fontWeight: FontWeight.w900),
              ),
      ),
    );
  }
}
