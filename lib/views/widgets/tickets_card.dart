// Ticket Card for My Tickets Page
import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final String seatNumber;
  final String seatCategory;
  final String qrCodeImage;

  TicketCard({
    required this.seatNumber,
    required this.seatCategory,
    required this.qrCodeImage,
  });
 
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text("Seat: $seatNumber", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Category: $seatCategory"),
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(qrCodeImage, width: 50, height: 50),
        ),
      ),
    );
  }
}