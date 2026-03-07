import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/models/seat_model.dart';
import 'package:get/get.dart';

class PreferredPriceController extends GetxController {
  var selectedOption = 'original'.obs; // 'original', '50%', '25%'
  late RxDouble totalPrice = 0.0.obs;
  var isLoading = false.obs;
  
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    try {
      CartController cartController = Get.find<CartController>();
      
      // If cart total is 0, try to load cart data
      if (cartController.totalPrice.value == 0) {
        
        _loadCartData();
      } else {
        // Initialize with current cart total value
        double basePrice = cartController.totalPrice.value.toDouble();
        totalPrice.value = basePrice;
        
      }
      
      // Listen for changes in selectedOption and cart total
      ever(selectedOption, (_) => _updateTotalPrice());
      ever(cartController.totalPrice, (_) {
        
        _updateTotalPrice();
      });
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
        Get.offAllNamed('/welcome'); // Navigate to home if no token
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
      
      // Now update our total price
      totalPrice.value = cartController.totalPrice.value.toDouble();
      isLoading.value = false;
      
    } catch (e) {
      
      totalPrice.value = 0.0;
      isLoading.value = false;
      // On error, also go back to home
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

  void _updateTotalPrice() {
    try {
      CartController cartController = Get.find<CartController>();
      double basePrice = cartController.totalPrice.value.toDouble();
      
      switch (selectedOption.value) {
        case '50%':
          totalPrice.value = basePrice * 0.5;
          break;
        case '25%':
          totalPrice.value = basePrice * 0.25;
          break;
        case 'original':
        default:
          totalPrice.value = basePrice;
          break;
      }
      
    } catch (e) {
      totalPrice.value = 0.0;
    }
  }

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }
}