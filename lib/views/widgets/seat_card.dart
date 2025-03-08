import 'package:flutter/material.dart';

// Seat Card for Cart Page
class SeatCard extends StatelessWidget {
  final String seatNumber;
  final String seatCategory;
  final double seatPrice;
  final String eventImage;
  final Duration timeLeft;

  SeatCard({
    required this.seatNumber,
    required this.seatCategory,
    required this.seatPrice,
    required this.eventImage,
    required this.timeLeft,
  });
 
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(eventImage, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text("Seat: $seatNumber", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: $seatCategory"),
            Text("Price: \$${seatPrice.toStringAsFixed(2)}"),
            Text("Time Left: ${timeLeft.inMinutes} min"),
          ],
        ),
        trailing: Icon(Icons.timer, color: Colors.red),
      ),
    );
  }
}