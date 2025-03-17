import 'package:darbelsalib/core/services/auth_service.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/models/user_model.dart'; // Import the UserModel

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  var userName = "".obs;

  // Register user with phone number
  Future<UserModel?> registerWithPhone(String password, String fullName, String phone) async {
    try {
      final UserModel? user = await _authService.registerWithPhone(password, fullName, phone);
      if (user != null) {
        userName.value = user.fullName; // Update the observable user name
        await _tokenStorageService.saveToken(user.token); // Save the token
        Get.snackbar("Success", "User registered successfully", backgroundColor: Colors.green);
        return user;
      } else {
        Get.snackbar("Error", "Failed to register", backgroundColor: Colors.red);
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
      return null;
    }
  }

  // Login user with phone number
  Future<UserModel?> loginWithPhone(String phone, String password) async {
    try {
      final UserModel? user = await _authService.loginWithPhone(phone, password);
      if (user != null) {
        userName.value = user.fullName; // Update the observable user name
        await _tokenStorageService.saveToken(user.token); // Save the token
        Get.snackbar("Success", "Logged in successfully", backgroundColor: Colors.green);
        return user;
      } else {
        Get.snackbar("Error", "Failed to login", backgroundColor: Colors.red);
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
      return null;
    }
  }

  // Forgot password (updated to use phone number)
  Future<void> forgotPassword(String phone) async {
    try {
      await _authService.sendPhoneVerification(phone);
      Get.snackbar("Success", "Password reset SMS sent", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  // Logout user (unchanged)
  Future<void> logout() async {
    await _tokenStorageService.clearToken(); // Clear the token
    userName.value = ""; // Reset the user name
    Get.offNamed('/login'); // Redirect to the login page
  }

  // Get the stored token (unchanged)
  Future<String?> getToken() async {
    return await _tokenStorageService.getToken();
  }
}