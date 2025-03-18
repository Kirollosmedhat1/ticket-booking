import 'dart:convert';

import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/views/widgets/seat_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();
  final List<Map<String, dynamic>> _selectedSeats = [];
  double _totalPrice = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getCart();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  static String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() +
        input
            .substring(1)
            .replaceAllMapped(RegExp(r'(\d+)'), (Match m) => ' ${m[0]}');
  }

  void removeFromCart(String seatID) async {
    try {
      String? token = await _tokenStorageService.getToken();
      var response = await _apiService.removeFromCart(token!, seatID);
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _selectedSeats.removeWhere((element) => element['id'] == seatID);
          });
        }
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
  }

  void requestPayment() async {
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

    setState(() {
      _selectedSeats.clear();
      _totalPrice = 0.0;
      for (var item in items) {
        String seatNumber = item['seat']['seat_number'];
        String seatId = item['seat']['id'];
        String category = _capitalize(item['seat']['category']['name']);
        int price = category == 'section1' || category == 'section2'
            ? 100
            : category == 'section3' || category == 'section4'
                ? 75
                : 50;
        _selectedSeats.add({
          'seatNumber': seatNumber,
          'category': category,
          'price': price,
          'id': seatId,
        });

        _totalPrice += price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: isLoading
          ? CustomLoadingIndicator()
          : _selectedSeats.isEmpty
              ? Center(
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
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _selectedSeats.length,
                        itemBuilder: (context, index) {
                          var seat = _selectedSeats[index];
                          return SeatCard(
                            seatNumber: seat['seatNumber'],
                            seatCategory: seat['category'],
                            seatPrice: seat['price'],
                            seatId: seat['id'],
                            onRemove: () {
                              removeFromCart(seat['id']);
                            },
                          );
                        },
                      ),
                    ),
                    Divider(),
                    _buildTotalPriceSection(),
                    SizedBox(height: 10),
                    _buildCheckoutButton(),
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
          Text(
            "${_totalPrice.toStringAsFixed(2)} EGP",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// **Navigates to Checkout Page**
  Widget _buildCheckoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: () async {
          requestPayment();
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
