import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Seat Card for Cart Page
class SeatCard extends StatefulWidget {
  final String seatNumber;
  final String seatCategory;
  final double seatPrice;
  // final DateTime? expiryTime;

  SeatCard({
    required this.seatNumber,
    required this.seatCategory,
    required this.seatPrice, required String eventImage, DateTime? expiryTime,
    // required this.expiryTime,
  });

  @override
  _SeatCardState createState() => _SeatCardState();
}

class _SeatCardState extends State<SeatCard> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;


  // @override
  // void initState() {
  //   super.initState();
  //   _updateTimeLeft();
  //   _startTimer();
  // }

  // void _updateTimeLeft() {
  //   if (widget.expiryTime != null) {
  //     setState(() {
  //       _timeLeft = widget.expiryTime!.difference(DateTime.now());
  //     });
  //   }
  // }

  // void _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (widget.expiryTime != null) {
  //       setState(() {
  //         _timeLeft = widget.expiryTime!.difference(DateTime.now());

  //         if (_timeLeft.isNegative) {
  //           _timeLeft = Duration.zero;
  //           _timer.cancel();
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;
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
              borderRadius: BorderRadius.circular(screenhight * 0.01),
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
                  TextSpan(text: "Seat: ${widget.seatNumber} \n"),
                  TextSpan(
                      text:
                          "Section: ${widget.seatCategory} \nPrice:  ${widget.seatPrice.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      )),
                  // TextSpan(
                  //   text:
                  //       "Time Left: ${_timeLeft.inMinutes}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}",
                  //   style: TextStyle(
                  //       fontSize: screenWidth * 0.04,
                  //       fontWeight: FontWeight.w400,
                  //       color: _timeLeft.inSeconds <= 30
                  //           ? Colors.red
                  //           : Colors.white),
                  // ),
                ]),
          ),
          SizedBox(
            width: screenWidth * 0.15,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // ticketController.removeSeat(widget.seatNumber);
            },
            tooltip: "Remove Seat",
          ),
        ],
      ),
    );
  }
}
