import 'package:darbelsalib/views/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class PastServiceImage extends StatelessWidget {
  const PastServiceImage({super.key, required this.imgName});

  final String imgName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/$imgName.jpg",
            height: 260,
            width: 199,
            fit: BoxFit.cover,
          ),
        ),
        SubtitleText(text: imgName)
      ],
    );
  }
}