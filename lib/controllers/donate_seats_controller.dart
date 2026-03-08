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
  late RxDouble displayPrice = 0.0.obs; // Total price displayed to user (seats + donations)
  var isLoading = false.obs;

  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _initializeController();
    // Listen for changes in extra seats
    ever(extraSeats, (_) => updateTotalPrice());
    
    // Listen for changes in preferred price selection
    try {
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      ever(preferredController.selectedOption, (_) => updateTotalPrice());
    } catch (e) {
      // PreferredPriceController not available yet, that's ok
    }
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
      CartController cartController = Get.find<CartController>();
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      
      int numberOfSeats = cartController.selectedSeats.length;
      double pricePerTicket = preferredController.getPricePerTicket();
      double seatPrice = numberOfSeats * pricePerTicket;
      
      totalPrice.value = seatPrice;
      displayPrice.value = seatPrice;
      
    } catch (e) {
      // Fallback: calculate based on cart total
      CartController cartController = Get.find<CartController>();
      double seatPrice = cartController.totalPrice.value.toDouble();
      totalPrice.value = seatPrice;
      displayPrice.value = seatPrice;
    }
  }

  void _refreshPreferredPrice() {
    try {
      CartController cartController = Get.find<CartController>();
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      
      int numberOfSeats = cartController.selectedSeats.length;
      double pricePerTicket = preferredController.getPricePerTicket();
      double seatsPrice = numberOfSeats * pricePerTicket;
      double donationCost = extraSeats.value * 100.0; // 100 EGP per donation seat
      
      totalPrice.value = seatsPrice + donationCost;
      displayPrice.value = seatsPrice + donationCost;
    } catch (e) {
      // If PreferredPriceController doesn't exist, just update based on current values
      updateTotalPrice();
    }
  }

  void refreshPriceFromPreferred() {
    try {
      CartController cartController = Get.find<CartController>();
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      
      int numberOfSeats = cartController.selectedSeats.length;
      double pricePerTicket = preferredController.getPricePerTicket();
      double seatsPrice = numberOfSeats * pricePerTicket;
      double donationCost = extraSeats.value * 100.0; // 100 EGP per donation seat
      
      totalPrice.value = seatsPrice + donationCost;
      displayPrice.value = seatsPrice + donationCost;
    } catch (e) {
      // Fallback
      updateTotalPrice();
    }
  }

  void setupListenersIfNeeded() {
    try {
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      // Re-establish listeners if they were lost
      ever(preferredController.selectedOption, (_) => updateTotalPrice());
    } catch (e) {
      // Controller still not available
    }
  }

  void updateTotalPrice() {
    try {
      CartController cartController = Get.find<CartController>();
      PreferredPriceController preferredController = Get.find<PreferredPriceController>();
      
      int numberOfSeats = cartController.selectedSeats.length;
      double pricePerTicket = preferredController.getPricePerTicket();
      double seatsPrice = numberOfSeats * pricePerTicket;
      double donationCost = extraSeats.value * 100.0; // 100 EGP per donation seat
      
      totalPrice.value = seatsPrice + donationCost;
      displayPrice.value = seatsPrice + donationCost; // Show total to user
      
    } catch (e) {
      totalPrice.value = 0.0;
      displayPrice.value = 0.0;
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

      // Get preferred price option to determine the price per ticket
      double? amount;
      try {
        PreferredPriceController preferredController =
            Get.find<PreferredPriceController>();
        String selectedOption = preferredController.selectedOption.value;
        CartController cartController = Get.find<CartController>();
        int numberOfSeats = cartController.selectedSeats.length;

        // Only send amount if user selected a price different from 200
        if (selectedOption != 'price_200') {
          double pricePerTicket;
          switch (selectedOption) {
            case 'price_100':
              pricePerTicket = 100.0;
              break;
            case 'price_75':
              pricePerTicket = 75.0;
              break;
            default:
              pricePerTicket = 200.0;
              break;
          }
          
          amount = numberOfSeats * pricePerTicket;
        } else {
          // If price_200 is selected, don't send amount (use backend default)
          amount = null;
        }
      } catch (e) {
        // If PreferredPriceController doesn't exist, use default price (200 per ticket)
        amount = null;
      }

      // Get donation amount only if user donated seats
      double? donationAmount;
      if (extraSeats.value > 0) {
        donationAmount = extraSeats.value * 100.0; // 100 EGP per seat
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