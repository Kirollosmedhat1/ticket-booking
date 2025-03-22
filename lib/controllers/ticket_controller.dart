import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/models/ticket_model.dart';
import 'package:get/get.dart'; // For state management (optional)
import 'package:flutter/material.dart';

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
          tickets.value = response
              .map((ticket) => TicketModel.fromJson(ticket))
              .toList(); // Update the reactive list
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      // Handle errors
      _showSnackBar("Error", "Failed to fetch tickets: $e", Colors.red);
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
      _showSnackBar("Error", "Failed to add ticket: $e", Colors.red);
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
      _showSnackBar("Error", "Failed to remove ticket: $e", Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackBar(String title, String message, Color backgroundColor) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
