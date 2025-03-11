import 'dart:async';
import 'package:darbelsalib/controllers/ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Seat Card for Cart Page
class SeatCard extends StatefulWidget {
  final String seatNumber;
  final String seatCategory;
  final double seatPrice;
  final String eventImage;
  final DateTime? expiryTime;

  SeatCard({
    required this.seatNumber,
    required this.seatCategory,
    required this.seatPrice,
    required this.eventImage,
    required this.expiryTime,
  });

  @override
  _SeatCardState createState() => _SeatCardState();
}

class _SeatCardState extends State<SeatCard> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
   final TicketController ticketController = Get.put(TicketController());

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _startTimer();
  }

  void _updateTimeLeft() {
    if (widget.expiryTime != null) {
      setState(() {
        _timeLeft = widget.expiryTime!.difference(DateTime.now());
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.expiryTime != null) {
        setState(() {
          _timeLeft = widget.expiryTime!.difference(DateTime.now());

          if (_timeLeft.isNegative) {
            _timeLeft = Duration.zero;
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(widget.eventImage, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text("Seat: ${widget.seatNumber}", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${widget.seatCategory}"),
            Text("Price: \$${widget.seatPrice.toStringAsFixed(2)}"),
            Text(
              "Time Left: ${_timeLeft.inMinutes}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(color: _timeLeft.inSeconds <= 30 ? Colors.red : Colors.black),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red), // Delete icon
          onPressed: () {
            ticketController.removeSeat(widget.seatNumber); // Remove seat from cart
          },
          tooltip: "Remove Seat",
        ),
      ),
    );
  }
}
