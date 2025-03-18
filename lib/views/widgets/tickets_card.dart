import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        border: Border.all(
          color: Color(0xffFCC434),
          width: screenWidth * 0.005,
        ),
      ),
      margin: EdgeInsets.fromLTRB(
        screenWidth * 0.04,
        screenWidth * 0.02,
        screenWidth * 0.04,
        screenWidth * 0.02,
      ),
      // ❌ REMOVE fixed height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.15,
            height: screenWidth * 0.15, // Square image
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenHeight * 0.01),
              image: DecorationImage(
                image: AssetImage("assets/images/card_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFCC434),
                ),
                children: [
                  TextSpan(text: "Seat: $seatNumber\n"),
                  TextSpan(
                    text: "Section: $seatCategory",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
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
    );
  }
}
