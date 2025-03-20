import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:darbelsalib/models/user_model.dart'; // Import the UserModel

class AuthService {
  static const String baseUrl =
      'https://darb-el-salib-f3e9ea716f85.herokuapp.com/api';

  Future<String?> registerWithEmail(String email, String password,
      String firstName, String lastName, String phone) async {
    try {
      final url = Uri.parse('$baseUrl/users/register/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "phone_number": phone,
          "password": password,
          "first_name": firstName,
          "last_name": lastName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          return responseData['message'];
        } else {
          return "Registration Failed.";
        }
      } else {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('phone_number') &&
            responseData.containsKey('email')) {
          return "Both email and phone number have been registered before.";
        } else if (responseData.containsKey('email')) {
          return "This email has been registered before.";
        } else if (responseData.containsKey('phone_number')) {
          return "This phone number has been registered before.";
        } else {
          throw Exception("Registration failed");
        }
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  /// **🔹 Login user with email**
  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/users/login/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserModel(
          id: responseData['user']['id'].toString(),
          fullName:
              "${responseData['user']['first_name']} ${responseData['user']['last_name']}",
          phone: responseData['user']['phone_number'],
          email: email,
          token: responseData['token'],
        );
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  /// **🔹 Send Email Verification**
  Future<void> sendEmailVerification(String email) async {
    try {
      final url = Uri.parse('$baseUrl/users/send-email-verification/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to send email verification: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to send email verification: $e");
    }
  }
}
