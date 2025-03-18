import 'dart:convert';

import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/models/seat_model.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/views/widgets/seat_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CartPage extends StatelessWidget {
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();
  final CartController _cartController = Get.put(CartController());
  final RxBool isLoading = false.obs;

  CartPage() {
    getCart();
  }

  static String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() +
        input
            .substring(1)
            .replaceAllMapped(RegExp(r'(\d+)'), (Match m) => ' ${m[0]}');
  }

  void removeFromCart(BuildContext context, Seat seat) async {
    isLoading.value = true;
    try {
      String? token = await _tokenStorageService.getToken();
      var response = await _apiService.removeFromCart(token!, seat.id);
      if (response.statusCode == 200) {
        _cartController.removeSeat(seat.seatNumber);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seat removed from cart successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove seat from cart.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('An error occurred while removing the seat from the cart.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    isLoading.value = false;
  }

  void requestPayment(BuildContext context) async {
    String? token = await _tokenStorageService.getToken();
    var response = await _apiService.requestPayment(token!);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = json.decode(response.body);
      String paymentUrl = responseData['url'];
      Uri redirectURL = Uri.parse(paymentUrl);
      if (await canLaunchUrl(redirectURL)) {
        await launchUrl(redirectURL);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not launch payment URL"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 10.0),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to request payment"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 10.0),
        ),
      );
    }
  }

  void getCart() async {
    String? token = await _tokenStorageService.getToken();
    var response = await _apiService.getUserCart(token!);
    List<dynamic> items = response['items'];

    _cartController.selectedSeats.clear();
    _cartController.totalPrice.value = 0;
    for (var item in items) {
      String seatNumber = item['seat']['seat_number'];
      String seatId = item['seat']['id'];
      String category = _capitalize(item['seat']['category']['name']);
      int price = category == 'Section 1' || category == 'Section 2'
          ? 100
          : category == 'Section 3' || category == 'Section 4'
              ? 75
              : 50;
      _cartController.addSeat(
          seatNumber,
          Seat(
              id: seatId,
              seatNumber: seatNumber,
              status: "selected",
              price: price,
              section: category));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: isLoading.value,
          progressIndicator: CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Obx(() {
            if (_cartController.selectedSeats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Seats Selected",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: GoBackText(
                        text: "Go Home",
                        onTap: () => Get.toNamed("/home"),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: _cartController.selectedSeats.length,
                        itemBuilder: (context, index) {
                          var seat = _cartController.selectedSeats.values.toList()[index];
                          return SeatCard(
                            seatNumber: seat.seatNumber,
                            seatCategory: seat.section,
                            seatPrice: seat.price.toDouble(),
                            seatId: seat.id,
                            onRemove: () {
                              removeFromCart(context, seat);
                            },
                          );
                        },
                      );
                    }),
                  ),
                  Divider(),
                  _buildTotalPriceSection(),
                  SizedBox(height: 10),
                  _buildCheckoutButton(context),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GoBackText(
                      text: "Go Home",
                      onTap: () => Get.toNamed("/home"),
                    ),
                  )
                ],
              );
            }
          }),
        );
      }),
    );
  }

  /// **Displays Total Price**
  Widget _buildTotalPriceSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Price:",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Obx(() {
            return Text(
              "${_cartController.totalPrice.value.toStringAsFixed(2)} EGP",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          }),
        ],
      ),
    );
  }

  /// **Navigates to Checkout Page**
  Widget _buildCheckoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: () async {
          requestPayment(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffdfa000),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          "Proceed to Checkout",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}