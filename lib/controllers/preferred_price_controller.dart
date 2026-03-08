import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/models/seat_model.dart';
import 'package:get/get.dart';

class PreferredPriceController extends GetxController {
  var selectedOption = 'price_200'.obs; // 'price_200', 'price_100', 'price_75'
  var isLoading = false.obs;

  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    // Just store the selected option, don't calculate prices here
    // Discount will be applied later in cart page after seats are selected
  }

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }

  // Get the price per ticket based on selected option
  double getPricePerTicket() {
    switch (selectedOption.value) {
      case 'price_100':
        return 100.0;
      case 'price_75':
        return 75.0;
      case 'price_200':
      default:
        return 200.0;
    }
  }
}
