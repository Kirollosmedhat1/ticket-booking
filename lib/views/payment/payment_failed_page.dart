import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxContentWidth = 400;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 100, color: Colors.redAccent),
                  SizedBox(height: 20),
                  Text(
                    "Payment Failed!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth > maxContentWidth ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Something went wrong.\nPlease try again.",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: screenWidth > maxContentWidth ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Try Again",
                    textcolor: Colors.black,
                    bordercolor: Color(0xffDFA000),
                    backgroundcolor: Color(0xffDFA000),
                    onPressed: () {
                      // You can customize where to redirect
                      Get.back(); // Goes back to previous page (payment)
                    },
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/home'); // Back to home
                    },
                    child: Text(
                      "Back to Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth > maxContentWidth ? 16 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
