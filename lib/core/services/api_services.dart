import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://cors-anywhere.herokuapp.com/https://darb-el-salib-f3e9ea716f85.herokuapp.com/api";

  Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/users/register/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, 
      body: jsonEncode(userData),
    );
    return response;
  }

  Future<http.Response> loginUser(Map<String, dynamic> credentials) async {
    final url = Uri.parse('$baseUrl/users/login/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );
    return response;
  }

  Future<http.Response> addToCart(String token, Map<String, dynamic> seatData) async {
    final url = Uri.parse('$baseUrl/cart/add-to-cart/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(seatData),
    );
    return response;
  }

  Future<http.Response> removeFromCart(String token, String seatId) async {
    final url = Uri.parse('$baseUrl/cart/remove/$seatId/');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    return response;
  }

  Future<http.Response> getUserCart(String token) async {
    final url = Uri.parse('$baseUrl/cart');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    return response;
  }

  Future<http.Response> getMyTickets(String token) async {
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    return response;
  }

  Future<http.Response> requestPayment(String token) async {
    final url = Uri.parse('$baseUrl/payments/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    return response;
  }

  Future<http.Response> paymentCallback(Map<String, dynamic> callbackData) async {
    final url = Uri.parse('$baseUrl/payments/callback/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(callbackData),
    );
    return response;
  }
}