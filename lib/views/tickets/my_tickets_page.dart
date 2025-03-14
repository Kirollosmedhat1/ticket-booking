// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:darbelsalib/views/widgets/seat_card.dart';
import 'package:flutter/material.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("My tickets"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                border: Border.all(
                    color: Color(0xffFCC434), width: screenWidth * 0.005)),
            margin: EdgeInsets.fromLTRB(
                screenWidth * 0.04, screenWidth * 0.02, screenWidth * 0.04, 0),
            height: screenWidth * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenhight*0.01),
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/images/card_image.png"),
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
                        TextSpan(text: "Seat: A22\n"),
                        TextSpan(
                            text: "Category: First Line\nPrice: 150 ",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ))
                      ]),
                ),
                SizedBox(width: screenWidth*0.15,),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), // Delete icon
                  onPressed: () {
                    // ticketController.removeSeat(widget.seatNumber); // Remove seat from cart
                  },
                  tooltip: "Remove Seat",
                ),
              ],
            ),
          ),
          SeatCard(seatNumber: "A22", seatCategory: "first Line", seatPrice: 150, ),
          Container(
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                border: Border.all(
                    color: Color(0xffFCC434), width: screenWidth * 0.005)),
            margin: EdgeInsets.fromLTRB(
                screenWidth * 0.04, screenWidth * 0.02, screenWidth * 0.04, 0),
            height: screenWidth * 0.25,
            child: Row(

              children: [
                Container(
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenhight*0.01),
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/images/card_image.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                 SizedBox(width: screenWidth*0.1,),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffFCC434),
                      ),
                      children: [
                        TextSpan(text: "Seat: A22\n"),
                        TextSpan(
                            text: "Category: First Line ",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ))
                      ]),
                ),
               
                
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
