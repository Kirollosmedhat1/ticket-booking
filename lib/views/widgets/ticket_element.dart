import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class TicketElement extends StatelessWidget {
  const TicketElement({
    super.key,
    required this.title,
    required this.subtitle,
    required this.img,
  });

  final String title;
  final String subtitle;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageIcon(
          AssetImage(img),
          size: ScreenSizeHandler.smaller * 0.112,
        ),
        SizedBox(width: ScreenSizeHandler.smaller * 0.023),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ScreenSizeHandler.smaller * 0.037,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: ScreenSizeHandler.smaller * 0.037,
                color: Color(0xFF000000),
              ),
            ),
          ],
        )
      ],
    );
  }
}