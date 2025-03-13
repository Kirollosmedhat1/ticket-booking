import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketsButton extends StatelessWidget {
  const MyTicketsButton({
    super.key,
    required this.image, required this.title,
  });
  final String title;
  final String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/tickets"),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenSizeHandler.smaller * 0.0326,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: ImageIcon(
                AssetImage(image),
                color: Colors.white,
                size: ScreenSizeHandler.smaller * 0.058,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
