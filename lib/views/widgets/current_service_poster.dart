import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/subtitle_text.dart';
import 'package:darbelsalib/views/widgets/title_text.dart';
import 'package:flutter/cupertino.dart';

class CurrentServicePoster extends StatelessWidget {
  const CurrentServicePoster({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SubtitleText(text: "Friday 4th of April, 7:00 PM"),
        Image.asset(
          "assets/images/HomePagePoster.png",
          width: ScreenSizeHandler.smaller*0.732,
        ),
        const TitleText(text: "Adam"),
        const SubtitleText(
            text: "• Biblical, Historical, Contemplation, Musical •"),
        const SubtitleText(text: "2h 29m")
      ],
    );
  }
}
