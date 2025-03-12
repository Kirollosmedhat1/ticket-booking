import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class SelectSection extends StatelessWidget {
  const SelectSection({super.key});

  Widget buildSectionBox(String section, bool isFinalRow) {
    double width = ScreenSizeHandler.screenWidth * (isFinalRow ? 0.2 : 0.25);
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 0.6666666666666666 * width,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color(0xFFDFA000),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          section,
          style: TextStyle(
            fontSize: ScreenSizeHandler.smaller * (isFinalRow? 0.03: 0.04),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Select Section',
          style: TextStyle(
              fontSize: ScreenSizeHandler.smaller * 0.065,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/screen.png",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionBox("Section 1", false),
                  buildSectionBox("Section 2", false),
                  buildSectionBox("Section 3", false),
                ],
              ),
              // Second row with 3 boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionBox("Section 4", false),
                  buildSectionBox("Section 5", false),
                  buildSectionBox("Section 6", false),
                ],
              ),
              // Third row with 4 boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionBox("Section 7", true),
                  buildSectionBox("Section 8", true),
                  buildSectionBox("Section 9", true),
                  buildSectionBox("Section 10", true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
