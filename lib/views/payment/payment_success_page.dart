import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxContentWidth = 400; // Max width constraint for large screens

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
                  Icon(Icons.check_circle_outline,
                      size: 100, color: Color(0xffDFA000)),
                  SizedBox(height: 20),
                  Text(
                    "Payment Successful!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth > maxContentWidth ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Thank you for your purchase.\nYour tickets are now confirmed.",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: screenWidth > maxContentWidth ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  OrderDetailsCard(
                      orderId: "#123456",
                      eventName: "Adam",
                      seats: "Section 3, Seats A4, A5",
                      totalPaid: "EGP 400"),
                  SizedBox(height: 30),
                  CustomButton(
                      text: "View My Tickets",
                      textcolor: Colors.black,
                      bordercolor: Color(0xffDFA000),
                      backgroundcolor: Color(0xffDFA000),
                      onPressed: () => Get.toNamed("/mytickets") ,
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
