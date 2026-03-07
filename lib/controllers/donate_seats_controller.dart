import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/controllers/preferred_price_controller.dart';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/models/seat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:web/web.dart' as web;

class DonateSeatsController extends GetxController {
  var extraSeats = 0.obs;
  late RxDouble totalPrice = 0.0.obs;
  var isLoading = false.obs;

  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _initializeController();
    // Listen for changes in extra seats
    ever(extraSeats, (_) => _updateTotalPrice());
  }

  void _initializeController() {
    try {
      CartController cartController = Get.find<CartController>();

      // If cart total is 0, need to load cart data
      if (cartController.totalPrice.value == 0) {
        
        _loadCartData(); // No await, it will update totalPrice when done
      } else {
        // Cart already has data, initialize price
        _initializePreferredPrice();
      }
    } catch (e) {
      
      totalPrice.value = 0.0;
    }
  }

  void _loadCartData() async {
    isLoading.value = true;
    try {
      String? token = await _tokenStorageService.getToken();
      if (token == null) {
        
        isLoading.value = false;
        Get.offAllNamed('/home');
        return;
      }

      var response = await _apiService.getUserCart(token);
      List<dynamic> items = response['items'];

      // If no items in cart, go back to home
      if (items.isEmpty) {
        
        isLoading.value = false;
        Get.offAllNamed('/home');
        return;
      }

      CartController cartController = Get.find<CartController>();
      cartController.selectedSeats.clear();
      cartController.totalPrice.value = 0;

      for (var item in items) {
        String seatNumber = item['seat']['seat_number'];
        String seatId = item['seat']['id'];
        String category = _capitalize(item['seat']['category']['name']);
        int price = 200;
        cartController.addSeat(
            seatNumber,
            Seat(
                id: seatId,
                seatNumber: seatNumber,
                status: "selected",
                price: price,
                section: category));
      }

      // Now initialize price using preferred controller if available, or cart total as fallback
      _initializePreferredPrice();
      isLoading.value = false;
      
    } catch (e) {
      
      totalPrice.value = 0.0;
      isLoading.value = false;
      Get.offAllNamed('/home');
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() +
        input
            .substring(1)
            .replaceAllMapped(RegExp(r'(\d+)'), (Match m) => ' ${m[0]}');
  }

  void _initializePreferredPrice() {
    try {
      // Try to find existing PreferredPriceController
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      totalPrice.value = preferredController.totalPrice.value;
      
    } catch (e) {
      // PreferredPriceController doesn't exist, calculate based on cart total
      // Default to 'original' price (100%)
      CartController cartController = Get.find<CartController>();
      double basePrice = cartController.totalPrice.value.toDouble();
      totalPrice.value = basePrice; // Default to original price
      
    }
  }

  void _updateTotalPrice() {
    try {
      double basePrice;

      // Try to get from PreferredPriceController, fallback to cart total
      try {
        PreferredPriceController preferredController = Get.find<PreferredPriceController>();
        basePrice = preferredController.totalPrice.value;
      } catch (e) {
        // Fallback to cart total with original pricing
        CartController cartController = Get.find<CartController>();
        basePrice = cartController.totalPrice.value.toDouble();
      }

      double extraCost = extraSeats.value * 200.0; // 200 EGP per extra seat
      totalPrice.value = basePrice + extraCost;
      
    } catch (e) {
      totalPrice.value = 0.0;
    }
  }

  void incrementSeats() {
    extraSeats.value++;
  }

  void decrementSeats() {
    if (extraSeats.value > 0) {
      extraSeats.value--;
    }
  }

  void setExtraSeats(int seats) {
    if (seats >= 0) {
      extraSeats.value = seats;
    }
  }

  Future<void> processCheckout(dynamic context) async {
    isLoading.value = true;
    try {
      // Get token
      String? token = await _tokenStorageService.getToken();
      if (token == null) {
        isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication error. Please login again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 10.0),
          ),
        );
        Get.offAllNamed('/login');
        return;
      }

      // Get preferred price option to determine if we need to send amount
      double? amount;
      try {
        PreferredPriceController preferredController =
            Get.find<PreferredPriceController>();
        String selectedOption = preferredController.selectedOption.value;

        // Only include amount if user selected something other than 'original'
        if (selectedOption != 'original') {
          CartController cartController = Get.find<CartController>();
          double basePrice = cartController.totalPrice.value.toDouble();
          double discountPercentage = selectedOption == '50%' ? 0.5 : 0.25;
          amount = basePrice * (discountPercentage);
        }
      } catch (e) {
        // If PreferredPriceController doesn't exist, we assume original price, so no amount needed
        amount = null;
      }

      // Get donation amount only if user donated seats
      double? donationAmount;
      if (extraSeats.value > 0) {
        donationAmount = extraSeats.value * 200.0; // 200 EGP per seat
      }

      // Call the API
      var response = await _apiService.requestPayment(
        token,
        amount: amount,
        donationAmount: donationAmount,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ;
        var responseData = json.decode(response.body);
        String paymentUrl = responseData['url'];
        Uri redirectURL = Uri.parse(paymentUrl);

        // Open URL in the same tab
        web.window.location.href = redirectURL.toString();
      } else {
        ;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process payment. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 10.0),
          ),
        );
      }
    } catch (e) {
      ;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 10.0),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}