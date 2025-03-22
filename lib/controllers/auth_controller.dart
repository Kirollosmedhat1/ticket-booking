import 'package:darbelsalib/core/services/auth_service.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/core/services/user_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/models/user_model.dart'; // Import the UserModel

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final UserStorageService _userStorageService = UserStorageService();
  var userName = "".obs;

  Future<String?> registerWithEmail(String email, String password,
      String firstName, String lastName, String phone) async {
    try {
      final String? message = await _authService.registerWithEmail(
          email, password, firstName, lastName, phone);

      if (message != null) {
        return message;
      } else {
        return "Failed to register";
      }
    } catch (e) {
      return "Registration failed: ${e.toString()}";
    }
  }

  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      final user = await _authService.loginWithEmail(email, password);
      if (user != null) {
        userName.value = user.fullName;
        await _tokenStorageService.saveToken(user.token);
        await _userStorageService.saveFullName(user.fullName);
        await _userStorageService.savePhoneNumber(user.phone);
        await _userStorageService.saveEmail(user.email);
        _showSnackBar("Success", "Logged in successfully", Colors.green);
        return user;
      } else {
        _showSnackBar("Error", "Failed to login", Colors.red);
        return null;
      }
    } catch (e) {
      if (e.toString().contains("Invalid credentials")) {
        _showSnackBar("Error", "Invalid email or password", Colors.red);
      } else {
        _showSnackBar("Error", e.toString(), Colors.red);
      }
      return null;
    }
  }

  // Logout user (unchanged)
  Future<void> logout() async {
    await _tokenStorageService.clearToken();
    await _userStorageService.clearUserDetails();
    userName.value = "";
    Get.offNamed('/login');
  }

  Future<String?> getToken() async {
    return await _tokenStorageService.getToken();
  }

  Future<String?> getFullName() async {
    return await _userStorageService.getFullName();
  }

  Future<String?> getPhoneNumber() async {
    return await _userStorageService.getPhoneNumber();
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
