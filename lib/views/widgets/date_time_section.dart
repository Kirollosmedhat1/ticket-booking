import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/ticket_element.dart';
import 'package:flutter/material.dart';

class DateTimeSection extends StatelessWidget {
  const DateTimeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TicketElement(
            title: "18h00",
            subtitle: "04.04.2025",
            img: 'assets/images/calendar.png'),
        Row(
          children: [
            Icon(Icons.watch_later_outlined, size: ScreenSizeHandler.smaller * 0.07),
            Padding(
              padding: EdgeInsets.only(left: ScreenSizeHandler.smaller * 0.018),
              child: Text("2 hours 29 minutes",
                  style: TextStyle(fontSize: ScreenSizeHandler.smaller * 0.032)),
            )
          ],
        )
      ],
    );
  }
}