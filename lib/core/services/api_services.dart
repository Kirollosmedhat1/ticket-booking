import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'darb-el-salib-f3e9ea716f85.herokuapp.com'; 

  // Register
  Future<http.Response> register({
    required String phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse('$baseUrl/users/register/');
    final body = {
      "phone_number": phoneNumber,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    };

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));

    return response;
  }

  // Login
  Future<http.Response> login({
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users/login/');
    final body = {
      "phone_number": phoneNumber,
      "password": password,
    };

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));

    return response;
  }

  // Add to cart
  Future<http.Response> addToCart(String token, String seatId) async {
    final url = Uri.parse('$baseUrl/cart/add-to-cart/');
    final body = {"seat_id": seatId};

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode(body));

    return response;
  }

  // Remove from cart
  Future<http.Response> removeFromCart(String token, String seatId) async {
    final url = Uri.parse('$baseUrl/cart/remove/$seatId/');
    final response = await http.delete(url, headers: {
      "Authorization": "Token $token",
    });

    return response;
  }

  // Get user cart
  Future<http.Response> getCart(String token) async {
    final url = Uri.parse('$baseUrl/cart');
    final response = await http.get(url, headers: {
      "Authorization": "Token $token",
    });

    return response;
  }

  // My Tickets
  Future<http.Response> getMyTickets(String token) async {
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.get(url, headers: {
      "Authorization": "Token $token",
    });

    return response;
  }

  // Checkout
  Future<http.Response> checkout(String token) async {
    final url = Uri.parse('$baseUrl/payments/');
    final response = await http.post(url, headers: {
      "Authorization": "Token $token",
    });

    return response;
  }
}
