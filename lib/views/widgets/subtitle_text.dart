import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/cupertino.dart';

class SubtitleText extends StatelessWidget {
  final String text;

  const SubtitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFFDFA000),
        fontSize: ScreenSizeHandler.smaller * 0.03488,
      ),
    );
  }
}
