import 'package:flutter/material.dart';
import 'dart:math'; // Import the math library for the min function

class SeatCard extends StatelessWidget {
  final String seatNumber;
  final String seatCategory;
  final double seatPrice;
  final String seatId;
  final VoidCallback onRemove;

  const SeatCard({
    required this.seatNumber,
    required this.seatCategory,
    required this.seatPrice,
    required this.seatId,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define maximum sizes for all elements
    final double maxWidth = 600.0; // Maximum width for the card
    final double maxHeight = 150.0; // Maximum height for the card
    final double maxFontSize = 20.0; // Maximum font size
    final double maxBorderRadius = 20.0; // Maximum border radius
    final double maxBorderWidth = 2.0; // Maximum border width
    final double maxImageSize = 80.0; // Maximum size for the image (width and height)
    final double maxIconSize = 30.0; // Maximum size for the icon
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
          0,
        ),
        height: min(screenWidth * 0.25, maxHeight), // Maximum height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: min(screenWidth * 0.15, maxImageSize), // Maximum image width
              height: min(screenWidth * 0.15, maxImageSize), // Maximum image height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(min(screenWidth * 0.05, maxBorderRadius)), // Maximum border radius
                image: DecorationImage(
                  image: AssetImage("assets/images/card_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: min(screenWidth * 0.05, maxFontSize), // Maximum font size
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFCC434),
                ),
                children: [
                  TextSpan(text: "Seat: $seatNumber \n"),
                  TextSpan(
                    text: "Section: $seatCategory \nPrice:  ${seatPrice.toStringAsFixed(2)} ",
                    style: TextStyle(
                      fontSize: min(screenWidth * 0.04, maxFontSize - 4), // Slightly smaller font
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: min(screenWidth * 0.15, 40.0), // Maximum spacing
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: min(screenWidth * 0.05, maxIconSize), // Maximum icon size
              ),
              onPressed: onRemove,
              tooltip: "Remove Seat",
            ),
          ],
        ),
      ),
    );
  }
}