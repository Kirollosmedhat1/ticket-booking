import 'package:flutter/material.dart';
import 'dart:math'; // Import the math library for the min function

class TicketsCard extends StatelessWidget {
  final String seatNumber;
  final String seatCategory;
  final String buyerName;
  final String buyerPhoneNumber;

  const TicketsCard({
    super.key,
    required this.seatNumber,
    required this.seatCategory,
    required this.buyerName,
    required this.buyerPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define maximum sizes for all elements
    final double maxWidth = 600.0; // Maximum width for the card
    final double maxHeight = 150.0; // Maximum height for the card
    final double maxFontSize = 20.0; // Maximum font size
    final double maxBorderRadius = 20.0; // Maximum border radius
    final double maxBorderWidth = 2.0; // Maximum border width
    final double maxImageSize = 80.0; // Maximum size for the image (width and height)
    final double maxPadding = 16.0; // Maximum padding
    final double maxMargin = 16.0; // Maximum margin

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth, // Maximum width for the card
          maxHeight: maxHeight, // Maximum height for the card
        ),
        padding: EdgeInsets.all(min(screenWidth * 0.03, maxPadding)), // Maximum padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(min(screenWidth * 0.05, maxBorderRadius)), // Maximum border radius
          border: Border.all(
            color: Color(0xffFCC434),
            width: min(screenWidth * 0.005, maxBorderWidth), // Maximum border width
          ),
        ),
        margin: EdgeInsets.fromLTRB(
          min(screenWidth * 0.04, maxMargin), // Maximum margin
          min(screenWidth * 0.02, maxMargin / 2),
          min(screenWidth * 0.04, maxMargin),
          min(screenWidth * 0.02, maxMargin / 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: min(screenWidth * 0.15, maxImageSize), // Maximum image width
              height: min(screenWidth * 0.15, maxImageSize), // Maximum image height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(min(screenHeight * 0.01, maxBorderRadius)), // Maximum border radius
                image: DecorationImage(
                  image: AssetImage("assets/images/card_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: min(screenWidth * 0.04, 16.0)), // Maximum spacing
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: min(screenWidth * 0.045, maxFontSize), // Maximum font size
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFCC434),
                  ),
                  children: [
                    TextSpan(text: "Seat: $seatNumber\n"),
                    TextSpan(
                      text: "Section: $seatCategory",
                      style: TextStyle(
                        fontSize: min(screenWidth * 0.04, maxFontSize - 4), // Slightly smaller font
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}