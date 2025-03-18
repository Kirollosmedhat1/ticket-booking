import 'package:flutter/material.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          border:
              Border.all(color: Color(0xffFCC434), width: screenWidth * 0.005)),
      margin: EdgeInsets.fromLTRB(
          screenWidth * 0.04, screenWidth * 0.02, screenWidth * 0.04, 0),
      height: screenWidth * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenHeight * 0.01),
              image: DecorationImage(
                image: AssetImage("assets/images/card_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFCC434),
                ),
                children: [
                  TextSpan(text: "Seat: $seatNumber \n"),
                  TextSpan(
                      text:
                          "Section: $seatCategory \nPrice:  ${seatPrice.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      )),
                ]),
          ),
          SizedBox(
            width: screenWidth * 0.15,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove,
            tooltip: "Remove Seat",
          ),
        ],
      ),
    );
  }
}