import 'dart:convert';

import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  // Fetch payment status from backend
  Future<Map<String, dynamic>> _fetchPaymentStatus() async {
    ApiService apiService = ApiService();
    TokenStorageService tokenStorageService = TokenStorageService();
    String? token = await tokenStorageService.getToken();
    String paymentId = Get.parameters['paymentId'] ?? '';
    // Remove the first character from payment id
    String paymentIdModified = paymentId.substring(1);
    var response = await apiService.paymentCallback(paymentIdModified, token!);
    var responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxContentWidth = 400;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchPaymentStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xffDFA000)));
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error loading payment status",
                    style: TextStyle(color: Colors.white)));
          } else {
            var responseData = snapshot.data ?? {};
            String status = responseData['status'] ?? 'failed';
            String amount = responseData['amount'] ?? '0.00';

            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display success, failure, or pending icon
                        Icon(
                          status == 'successful'
                              ? Icons.check_circle_outline
                              : status == 'pending'
                                  ? Icons.hourglass_empty
                                  : Icons.error_outline,
                          size: 100,
                          color: status == 'successful'
                              ? Color(0xffDFA000)
                              : status == 'pending'
                                  ? Colors.orangeAccent
                                  : Colors.redAccent,
                        ),
                        SizedBox(height: 20),
                        // Display success, failure, or pending message
                        Text(
                          status == 'successful'
                              ? "Payment Successful!"
                              : status == 'pending'
                                  ? "Payment Pending!"
                                  : "Payment Failed!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth > maxContentWidth ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          status == 'successful'
                              ? "Thank you for your purchase.\nYour tickets are now confirmed."
                              : status == 'pending'
                                  ? "Your payment is still being processed.\nPlease check back later.\nIf successful you should see it in your tickets."
                                  : "Something went wrong.\nPlease try again.",
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: screenWidth > maxContentWidth ? 18 : 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        // Display order details only for successful payment
                        if (status == 'successful')
                          OrderDetailsCard(
                            orderId:
                                Get.parameters['paymentId']?.substring(1) ?? '',
                            eventName: "Adam", // Replace with actual event name
                            totalPaid: "EGP $amount", // Use the parsed amount
                          ),
                        SizedBox(height: 30),
                        // Display appropriate button based on payment status
                        CustomButton(
                          text: status == 'successful'
                              ? "View My Tickets"
                              : "Try Again",
                          textcolor: Colors.black,
                          bordercolor: Color(0xffDFA000),
                          backgroundcolor: Color(0xffDFA000),
                          onPressed: () {
                            if (status == 'successful') {
                              Get.toNamed("/mytickets");
                            } else {
                              // Refresh Page
                              // pop the current page and push it again
                              Get.offNamed(Get.currentRoute);
                            }
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
            );
          }
        },
      ),
    );
  }
}
