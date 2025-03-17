import 'package:darbelsalib/core/services/auth_service.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/models/user_model.dart'; // Import the UserModel

class AuthController extends GetxController {
  final AuthService _authService = AuthService(); // Initialize AuthService
  final TokenStorageService _tokenStorageService = TokenStorageService(); // Initialize TokenStorageService
  var userName = "".obs; // Observable for user name

  // Register user using the API
  Future<UserModel?> registerWithEmail(String email, String password, String fullName, String phone) async {
    try {
      final UserModel? user = await _authService.registerWithEmail(email, password, fullName, phone);
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

  // Login user using the API
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


  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _authService.sendEmailVerification(email);
      Get.snackbar("Success", "Password reset email sent", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  // Logout user
  Future<void> logout() async {
    await _tokenStorageService.clearToken(); // Clear the token
    userName.value = ""; // Reset the user name
    Get.offNamed('/login'); // Redirect to the login page
  }

  // Get the stored token
  Future<String?> getToken() async {
    return await _tokenStorageService.getToken();
  }
}