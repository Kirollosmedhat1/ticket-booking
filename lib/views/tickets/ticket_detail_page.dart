import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:web/web.dart' as web;

class TicketDetailsPage extends StatelessWidget {
  final String eventBanner;
  final String seatNumber;
  final String seatCategory;

  TicketDetailsPage({
    required this.eventBanner,
    required this.seatNumber,
    required this.seatCategory,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey _ticketKey = GlobalKey();

    Future<void> _captureAndDownloadTicket() async {
      try {
        // Find the render boundary
        RenderRepaintBoundary boundary = _ticketKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);

        // Convert image to byte data
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Convert bytes to Base64
        final base64String = base64Encode(pngBytes);
        final dataUrl = "data:image/png;base64,$base64String";

        // Use web.HTMLAnchorElement for download
        final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
          ..href = dataUrl
          ..target = '_blank'
          ..download = "$seatCategory $seatNumber.png";
        anchor.click(); // Trigger download
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error saving ticket: $e")));
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Ticket Details',
          style: TextStyle(
              fontSize: ScreenSizeHandler.smaller * 0.06,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: ScreenSizeHandler.smaller * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(ScreenSizeHandler.smaller * 0.028),
                  child: Image.asset(eventBanner,
                      width: ScreenSizeHandler.smaller * 0.894,
                      height: ScreenSizeHandler.smaller * 0.588,
                      fit: BoxFit.cover),
                ),
              ),
              RepaintBoundary(
                key: _ticketKey,
                child: Ticket(
                  seatCategory: seatCategory,
                  seatNumber: seatNumber,
                ),
              ),
              GestureDetector(
                onTap: _captureAndDownloadTicket,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: ScreenSizeHandler.smaller * 0.023),
                        child: Icon(
                          Icons.download,
                          size: ScreenSizeHandler.smaller * 0.058,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Download This Ticket",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenSizeHandler.smaller * 0.037,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness:
                                ScreenSizeHandler.smaller * 0.005),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}