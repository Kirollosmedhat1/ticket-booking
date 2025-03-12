import 'package:darbelsalib/views/widgets/title_text.dart';
import 'package:flutter/material.dart';

class HomePageSection extends StatelessWidget {
  final String title;
  final Widget content;

  const HomePageSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: TitleText(
              text: title,
            ),
          ),
        ),
        content
      ],
    );
  }
}