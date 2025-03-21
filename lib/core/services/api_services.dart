import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://darb-el-salib-f3e9ea716f85.herokuapp.com/api";

  Future<http.Response> addToCart(
      String token, Map<String, dynamic> seatData) async {
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
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

  Future<dynamic> getUserCart(String token) async {
    final url = Uri.parse('$baseUrl/cart/');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return response;
    }
  }

  Future<dynamic> getMyTickets(String token) async {
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the list of tickets
    } else {
      throw Exception("Failed to fetch tickets: ${response.body}");
    }
  }

  Future<http.Response> requestPayment(String token) async {
    final url = Uri.parse('$baseUrl/payments/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

  Future<http.Response> paymentCallback(String id, String token) async {
    final url = Uri.parse('$baseUrl/payments/$id');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );
    return response;
  }
}
