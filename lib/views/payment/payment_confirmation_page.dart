import 'dart:convert';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  // Extract payment ID from route or query parameters
  String _extractPaymentId() {
    // Try path parameters first (from route like /payment-confirmation/:paymentId)
    String paymentId = Get.parameters['paymentId'] ?? '';

    // If not found, try GetX query parameters Map
    if (paymentId.isEmpty && Get.arguments != null) {
      if (Get.arguments is Map) {
        paymentId = Get.arguments['paymentId'] ?? '';
      }
    }

    // Remove leading special characters if present
    if (paymentId.isNotEmpty &&
        (paymentId.startsWith('-') || paymentId.startsWith('_'))) {
      paymentId = paymentId.substring(1);
    }

    // Remove the $ if exists in payment id
    if (paymentId.contains('\$')) {
      paymentId = paymentId.replaceAll('\$', '');
    }

    return paymentId;
  }

  // Fetch payment status from backend
  Future<Map<String, dynamic>> _fetchPaymentStatus() async {
    ApiService apiService = ApiService();
    TokenStorageService tokenStorageService = TokenStorageService();
    String? token = await tokenStorageService.getToken();

    String paymentId = _extractPaymentId();

    if (paymentId.isEmpty) {
      throw Exception('No payment ID found');
    }

    try {
      var response = await apiService.paymentCallback(paymentId, token);
      var responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw Exception('Failed to fetch payment status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxContentWidth = 400;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<String?>(
        future: TokenStorageService().getToken(),
        builder: (context, tokenSnapshot) {
          if (tokenSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xffDFA000)));
          }

          String? token = tokenSnapshot.data;
          bool hasToken = token != null;

          return FutureBuilder<Map<String, dynamic>>(
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
                status = status.toLowerCase();
                String amount = responseData['amount'] ?? '0.00';

                // Treat pending status as failed
                bool isSuccess = status == 'paid';

                return Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Display success or failure icon
                            Icon(
                              isSuccess
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              size: 100,
                              color: isSuccess
                                  ? Color(0xffDFA000)
                                  : Colors.redAccent,
                            ),
                            SizedBox(height: 20),
                            // Display success or failure message
                            Text(
                              isSuccess
                                  ? "Payment Successful!"
                                  : "Payment Failed!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    screenWidth > maxContentWidth ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              isSuccess
                                  ? "Thank you for your purchase."
                                  : "Something went wrong.\nPlease try again.",
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize:
                                    screenWidth > maxContentWidth ? 18 : 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                            // Display order details only for successful payment
                            if (isSuccess)
                              OrderDetailsCard(
                                orderId: _extractPaymentId(),
                                eventName:
                                    "Anya", // Replace with actual event name
                                totalPaid:
                                    "EGP $amount", // Use the parsed amount
                              ),
                            SizedBox(height: 30),
                            // Display button only if token is available
                            if (hasToken)
                              CustomButton(
                                text:
                                    isSuccess ? "View My Tickets" : "Try Again",
                                textcolor: Colors.black,
                                bordercolor: Color(0xffDFA000),
                                backgroundcolor: Color(0xffDFA000),
                                onPressed: () {
                                  if (isSuccess) {
                                    Get.toNamed("/mytickets");
                                  } else {
                                    Get.toNamed('/cart');
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
                                  fontSize:
                                      screenWidth > maxContentWidth ? 16 : 14,
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
          );
        },
      ),
    );
  }
}
