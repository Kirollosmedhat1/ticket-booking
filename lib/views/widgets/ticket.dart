import 'dart:convert';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/date_time_section.dart';
import 'package:darbelsalib/views/widgets/location_section.dart';
import 'package:darbelsalib/views/widgets/ticket_element.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Ticket extends StatelessWidget {
  const Ticket({
    super.key,
    required this.seatCategory,
    required this.seatNumber,
  });

  final String seatCategory;
  final String seatNumber;

  @override
  Widget build(BuildContext context) {
    // Encode the seat number and seat category into a JSON string
    final qrData = jsonEncode({
      'seatNumber': seatNumber,
      'seatCategory': seatCategory,
    });

    return Container(
      width: ScreenSizeHandler.smaller * 0.894,
      margin: EdgeInsets.only(
          left: ScreenSizeHandler.smaller * 0.046,
          right: ScreenSizeHandler.smaller * 0.046,
          top: ScreenSizeHandler.smaller * 0.081,
          bottom: ScreenSizeHandler.smaller * 0.046),
      padding: EdgeInsets.all(ScreenSizeHandler.smaller * 0.046),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenSizeHandler.smaller * 0.028),
      ),
      child: Column(
        children: [
          TicketElement(
              title: seatCategory,
              subtitle: seatNumber,
              img: 'assets/images/chair.png'),
          SizedBox(height: ScreenSizeHandler.smaller * 0.046),
          DateTimeSection(),
          SizedBox(height: ScreenSizeHandler.smaller * 0.046),
          LocationSection(),
          SizedBox(height: ScreenSizeHandler.smaller * 0.046),
          Row(
            children: [
              Icon(Icons.document_scanner_outlined,
                  size: ScreenSizeHandler.smaller * 0.07),
              Padding(
                padding:
                    EdgeInsets.only(left: ScreenSizeHandler.smaller * 0.018),
                child: Text(
                  "Show this QR Code",
                  style: TextStyle(
                      fontSize: ScreenSizeHandler.smaller * 0.032,
                      color: Colors.black),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenSizeHandler.smaller * 0.023),
            child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: ScreenSizeHandler.smaller * 0.465),
          ),
        ],
      ),
    );
  }
}
