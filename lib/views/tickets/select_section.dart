import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';

class SelectSection extends StatelessWidget {
  const SelectSection({super.key});

  Widget buildSectionBox(String section) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          section,
          style: TextStyle(
            fontSize: ScreenSizeHandler.smaller * 0.05,
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
                  buildSectionBox("Section 1"),
                  buildSectionBox("Section 2"),
                  buildSectionBox("Section 3"),
                ],
              ),
              // Second row with 3 boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionBox("Section 4"),
                  buildSectionBox("Section 5"),
                  buildSectionBox("Section 6"),
                ],
              ),
              // Third row with 4 boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionBox("Section 7"),
                  buildSectionBox("Section 8"),
                  buildSectionBox("Section 9"),
                  buildSectionBox("Section 10"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
