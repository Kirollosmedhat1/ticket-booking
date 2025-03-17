
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:darbelsalib/models/user_model.dart'; // Import the UserModel

class AuthService {
  static const String baseUrl =
      'https://darb-el-salib-f3e9ea716f85.herokuapp.com/api';

  /// **🔹 Register a new user with phone number**
  Future<UserModel?> registerWithPhone(
      String password, String fullName, String phone) async {
    try {
      final url = Uri.parse('$baseUrl/users/register/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone_number": phone,
          "password": password,
          "first_name": fullName.split(" ").first,
          "last_name": fullName.split(" ").last,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return UserModel(
          id: responseData['user']['id'].toString(),
          fullName:
              "${responseData['user']['first_name']} ${responseData['user']['last_name']}",
          phone: phone,
          token: responseData['token'], // Ensure the API returns a token
        );
      } else {
        throw Exception("Registration failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  /// **🔹 Login user with phone number**
  Future<UserModel?> loginWithPhone(String phone, String password) async {
    try {
      final url = Uri.parse('$baseUrl/users/login/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone_number": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserModel(
          id: responseData['user']['id'].toString(),
          fullName:
              "${responseData['user']['first_name']} ${responseData['user']['last_name']}",
          phone: phone,
          token: responseData['token'], // Ensure the API returns a token
        );
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
