import 'package:darbelsalib/views/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final List<Map<String, String>> images;
  final bool hasSubtitles;

  const ImageViewer({
    super.key,
    required this.images,
    required this.hasSubtitles,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, 
      child: Row(
        children: images.map((image) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/images/${image['imgName']}.jpg",
                    height: 260,
                    width: 199,
                    fit: BoxFit.cover,
                  ),
                ),
                if (hasSubtitles) SubtitleText(text: image['imgName']!)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}