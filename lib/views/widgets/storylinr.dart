import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class Storyline extends StatelessWidget {
  const Storyline({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = ScreenSizeHandler.smaller * 0.037;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Permissible age:\n\nLanguage:\n",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
            ),
            SizedBox(width: ScreenSizeHandler.screenWidth*0.1,),
            RichText(
              text: TextSpan(
                text:  "13+\n\nArabic\n",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        Text(
          "Storyline",
          style: TextStyle(
            fontSize: fontSize * 1.7,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),

        Text(
          "\nStory of creation, falling, and the salvation of your soul.",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
