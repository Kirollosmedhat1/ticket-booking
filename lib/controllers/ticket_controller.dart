
  

  import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:get/get.dart'; // For state management (optional)

class TicketController extends GetxController {
  final ApiService _apiService = ApiService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  // Reactive list of tickets
  var tickets = <dynamic>[].obs;
  var isLoading = false.obs;

  // Fetch tickets for the authenticated user
  Future<void> fetchTickets() async {
  try {
    isLoading.value = true; // Start loading
    final token = await _tokenStorageService.getToken();

    if (token != null) {
      final response = await _apiService.getMyTickets(token);

      if (response is List) {
        tickets.value = response; // Update the reactive list
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("User not authenticated");
    }
  } catch (e) {
    // Handle errors
    Get.snackbar("Error", "Failed to fetch tickets: $e");
  } finally {
    isLoading.value = false; // Stop loading
  }
}

  // Add a ticket (example)
  Future<void> addTicket(Map<String, dynamic> ticketData) async {
    try {
      isLoading.value = true;
      final token = await _tokenStorageService.getToken();

      if (token != null) {
        final response = await _apiService.addToCart(token, ticketData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Ticket added successfully
          fetchTickets(); // Refresh the list of tickets
        } else {
          throw Exception("Failed to add ticket: ${response.body}");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add ticket: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Remove a ticket (example)
  Future<void> removeTicket(String ticketId) async {
    try {
      isLoading.value = true;
      final token = await _tokenStorageService.getToken();

      if (token != null) {
        final response = await _apiService.removeFromCart(token, ticketId);

        if (response.statusCode == 200) {
          // Ticket removed successfully
          fetchTickets(); // Refresh the list of tickets
        } else {
          throw Exception("Failed to remove ticket: ${response.body}");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove ticket: $e");
    } finally {
      isLoading.value = false;
    }
  }
}