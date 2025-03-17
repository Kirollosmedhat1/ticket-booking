import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/tickets/select_seat.dart';
import 'package:darbelsalib/views/widgets/custom_appbar.dart';
import 'package:darbelsalib/views/widgets/custom_seat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectSection extends StatelessWidget {
  const SelectSection({super.key});

  Widget buildSectionTrapezium(
      String section, bool isFinalRow, double topWidth, double bottomWidth) {
    double height = ScreenSizeHandler.smaller *
        (isFinalRow ? 0.3 : 0.25) *
        0.6666666666666666;
    return GestureDetector(
      onTap: () {
        Get.toNamed('/selectseat/${int.parse(section.split(' ')[1])}');
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(ScreenSizeHandler.smaller * (0.25), height),
              painter: TrapeziumPainter(
                  topWidth: topWidth, bottomWidth: bottomWidth),
            ),
            Text(
              section,
              style: TextStyle(
                fontSize: ScreenSizeHandler.smaller * (0.04),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:const CustomAppBar(title: "Select Section"),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/screen.png",
                      ),
                    ),
                    // Wide container to resemble the stage
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      height: ScreenSizeHandler.smaller * 0.15,
                      width: ScreenSizeHandler.smaller * 0.88,
                      //rounded corners
                      decoration: BoxDecoration(
                        color: Color(0xFFDFA000),
                        //black outline
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("STAGE",
                            style: TextStyle(
                              fontSize: ScreenSizeHandler.smaller * 0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSectionTrapezium('Section 1', false, 100, 150),
                        SizedBox(width: 100),
                        buildSectionTrapezium('Section 2', false, 100, 150),
                      ],
                    ),
                    // Second row with 3 boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSectionTrapezium('Section 3', false, 150, 190),
                        SizedBox(width: 100),
                        buildSectionTrapezium('Section 4', false, 150, 190)
                      ],
                    ),
                    // Third row with 4 boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSectionTrapezium('Section 5', true, 120, 140),
                        SizedBox(width: 90),
                        buildSectionTrapezium('Section 6', true, 120, 140)
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("Please Choose a Selection to Proceed",
                        style: TextStyle(
                          fontSize: ScreenSizeHandler.smaller * 0.04,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrapeziumPainter extends CustomPainter {
  final double topWidth;
  final double bottomWidth;

  TrapeziumPainter({required this.topWidth, required this.bottomWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo((size.width - topWidth) / 2, 0)
      ..lineTo((size.width + topWidth) / 2, 0)
      ..lineTo((size.width + bottomWidth) / 2, size.height)
      ..lineTo((size.width - bottomWidth) / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = const Color(0xFFDFA000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
