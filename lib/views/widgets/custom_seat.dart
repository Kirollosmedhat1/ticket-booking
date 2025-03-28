import 'package:darbelsalib/models/seat_model.dart';
import 'package:flutter/material.dart';
// ...existing code...

class CustomSeat extends StatelessWidget {
  final Seat seat;
  final Function(String) onSeatSelected;

  CustomSeat({
    required this.seat,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color seatColor;
    bool isDisabled = false;
    Color textColor = Colors.white;

    switch (seat.status) {
      case "empty":
        seatColor = Colors.black;
        isDisabled = true;
        break;
      case "available":
        seatColor = Color(0xff1c1c1c);
        break;
      case "reserved":
        seatColor = Colors.red;
        isDisabled = true;
        textColor = Colors.white; // Better readability
        break;
      case "booked":
        seatColor = Color(0xffdfa000);
        isDisabled = true;
        break;
      case "selected":
        seatColor = Color(0xff7cc3f6);
        break;
      default:
        seatColor = Colors.black;
    }

    return GestureDetector(
      onTap: isDisabled ? null : () => onSeatSelected(seat.seatNumber),
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.001),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.006,
          ),
          border: Border.all(
            color: Colors.black,
            width: MediaQuery.of(context).size.width * 0.001,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          seat.seatNumber,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
