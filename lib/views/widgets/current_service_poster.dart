import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:darbelsalib/views/widgets/subtitle_text.dart';
import 'package:darbelsalib/views/widgets/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CurrentServicePoster extends StatelessWidget {
  const CurrentServicePoster({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/currentservice"),
      child: Column(
        children: [
          const SubtitleText(text: "Saturday 28th of March, 7:00 PM"),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(16.0), // Adjust the radius as needed
            child: Image.asset(
              "assets/images/2026poster.jpeg",
              width: ScreenSizeHandler.smaller * 0.732,
            ),
          ),
          const TitleText(text: "Anya"),
          const SubtitleText(
              text: "• Biblical, Historical, Contemplation, Musical •"),
          const SubtitleText(text: "2h 29m"),
          const SizedBox(
            height: 20,
          ),
          GoBackText(
              text: "Click Here to Book",
              onTap: () => Get.toNamed("/currentservice"))
        ],
      ),
    );
  }
}
