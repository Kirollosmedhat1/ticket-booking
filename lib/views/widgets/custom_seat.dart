import 'package:flutter/material.dart';

class CustomSeat extends StatelessWidget {
  final String seatNumber;
  final String status; 
  final Function(String) onSeatSelected;

  CustomSeat({
    required this.seatNumber,
    required this.status,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color seatColor;
    bool isDisabled = false;
    Color textColor = Colors.white;

    switch (status) {
      case "available":
        seatColor = Colors.green;
        break;
      case "reserved":
        seatColor = Colors.yellow;
        isDisabled = true;
        textColor = Colors.black; // Better readability
        break;
      case "booked":
        seatColor = Colors.red;
        isDisabled = true;
        break;
      default:
        seatColor = Colors.grey;
    }

    return GestureDetector(
      onTap: isDisabled ? null : () => _confirmSelection(context, seatNumber),
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width  * 0.001),
        width: MediaQuery.of(context).size.width  * 0.03,
        height: MediaQuery.of(context).size.width  * 0.03,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width  * 0.006,),
          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.width  * 0.001,),
        ),
        alignment: Alignment.center,
        child: Text(
          seatNumber,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width  * 0.006,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  /// Show Confirmation Dialog Before Selecting a Seat
  void _confirmSelection(BuildContext context, String seatNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Selection"),
        content: Text("Do you want to reserve seat $seatNumber?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              onSeatSelected(seatNumber);
              Navigator.pop(context); // Confirm
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
}
