import 'package:flutter/material.dart';

class TicketDetailsPage extends StatelessWidget {
  final String eventBanner;
  final String seatNumber;
  final String seatCategory;
  final String qrCodeImage;

  TicketDetailsPage({
    required this.eventBanner,
    required this.seatNumber,
    required this.seatCategory,
    required this.qrCodeImage,
  });
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ticket Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(eventBanner, width: double.infinity, height: 200, fit: BoxFit.cover),
          SizedBox(height: 16),
          Text("Seat: $seatNumber", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Category: $seatCategory", style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(qrCodeImage, width: 200, height: 200),
            ),
          ),
        ],
      ),
    );
  }
}