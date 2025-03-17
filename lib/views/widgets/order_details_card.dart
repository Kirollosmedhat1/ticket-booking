import 'package:flutter/material.dart';

class OrderDetailsCard extends StatelessWidget {
  final String orderId;
  final String eventName;
  final String seats;
  final String totalPaid;

  const OrderDetailsCard({
    super.key,
    required this.orderId,
    required this.eventName,
    required this.seats,
    required this.totalPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( // Order ID
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order ID", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              Text(orderId, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 8),
          Row( // Event Name
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Event", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              Text(eventName, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 8),
          Row( // Seats
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Seats", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              Text(seats, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 8),
          Row( // Total Paid
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Paid", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              Text(totalPaid, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
