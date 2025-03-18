
import 'dart:convert';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentConfirmationPage extends StatelessWidget {
  final String paymentId;

  const PaymentConfirmationPage({super.key, required this.paymentId});

  // Fetch payment status from backend using ApiService
  Future<bool> _fetchPaymentStatus() async {
// <<<<<<< HEAD
//     print('hena');
//     ApiService apiService = ApiService();
//     TokenStorageService tokenStorageService = TokenStorageService();
//     String? token = await tokenStorageService.getToken();
//     // Replace this with actual API call to fetch payment status
//     var response = await apiService.paymentCallback(paymentId, token!);
//     print(response);
//     print(response.body);
//     print(jsonDecode(response.body));
//     return false;
// =======
    final apiService = ApiService();
    final callbackData = {
      "customerReference": paymentId, // Use the paymentId passed to the widget
      "status": "success" // or "failed", depending on the actual status
    };

    try {
      final response = await apiService.paymentCallback(callbackData);

      // Debug: Print the raw response
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        // Debug: Print the parsed response body
        print("Parsed response body: $responseBody");

        // Check if the response contains a 'status' field and if it is 'success'
        if (responseBody.containsKey('status')) {
          return responseBody['status'] == "success";
        } else {
          print("Response does not contain a 'status' field");
          return false;
        }
      } else {
        print("Callback failed: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Error during callback: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxContentWidth = 400;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<bool>(
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
            bool isPaymentSuccessful = snapshot.data ?? false;

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
                          isPaymentSuccessful
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          size: 100,
                          color: isPaymentSuccessful
                              ? Color(0xffDFA000)
                              : Colors.redAccent,
                        ),
                        SizedBox(height: 20),
                        // Display success or failure message
                        Text(
                          isPaymentSuccessful
                              ? "Payment Successful!"
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
                          isPaymentSuccessful
                              ? "Thank you for your purchase.\nYour tickets are now confirmed."
                              : "Something went wrong.\nPlease try again.",
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: screenWidth > maxContentWidth ? 18 : 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        // Display order details only for successful payment
                        if (isPaymentSuccessful)
                          OrderDetailsCard(
                            orderId: "#123456",
                            eventName: "Adam",
                            seats: "Section 3, Seats A4, A5",
                            totalPaid: "EGP 400",
                          ),
                        SizedBox(height: 30),
                        // Display appropriate button based on payment status
                        CustomButton(
                          text: isPaymentSuccessful
                              ? "View My Tickets"
                              : "Try Again",
                          textcolor: Colors.black,
                          bordercolor: Color(0xffDFA000),
                          backgroundcolor: Color(0xffDFA000),
                          onPressed: () {
                            if (isPaymentSuccessful) {
                              Get.toNamed("/mytickets");
                            } else {
                              Get.back(); // Retry payment
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
