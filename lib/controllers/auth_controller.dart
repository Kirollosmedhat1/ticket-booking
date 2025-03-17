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

  // Register user with phone number
  Future<UserModel?> registerWithPhone(
      String password, String fullName, String phone) async {
    try {
      final UserModel? user =
          await _authService.registerWithPhone(password, fullName, phone);
      if (user != null) {
        userName.value = user.fullName; // Update the observable user name
        await _tokenStorageService.saveToken(user.token); // Save the token
        await _userStorageService.saveFullName(user.fullName); // Save the full name
        await _userStorageService.savePhoneNumber(user.phone); // Save the phone number
        Get.snackbar("Success", "User registered successfully",
            backgroundColor: Colors.green);
        return user;
      } else {
        Get.snackbar("Error", "Failed to register",
            backgroundColor: Colors.red);
        return null;
      }
    } catch (e) {
      //checks if error contains "phone number already exists" and show a snackbar accordingly
      if (e.toString().contains("phone number already exists")) {
        Get.snackbar("Error", "A User with this Phone Number Already Exists",
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
      }
      return null;
    }
  }

  // Login user with phone number
  Future<UserModel?> loginWithPhone(String phone, String password) async {
    try {
      final user =
          await _authService.loginWithPhone(phone, password);
      if (user != null) {
        userName.value = user.fullName; // Update the observable user name
        await _tokenStorageService.saveToken(user.token); // Save the token
        await _userStorageService.saveFullName(user.fullName); // Save the full name
        await _userStorageService.savePhoneNumber(user.phone); // Save the phone number
        Get.snackbar("Success", "Logged in successfully",
            backgroundColor: Colors.green);
        return user;
      } else {
        Get.snackbar("Error", "Failed to login", backgroundColor: Colors.red);
        return null;
      }
    } catch (e) {
      //checks if user is unauthorized and show a snackbar accordingly
      if (e.toString().contains("Invalid credentials")) {
        Get.snackbar("Error", "Invalid phone number or password",
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
      }

      return null;
    }
  }

  // Logout user (unchanged)
  Future<void> logout() async {
    await _tokenStorageService.clearToken(); // Clear the token
    await _userStorageService.clearUserDetails(); // Clear the user details
    userName.value = ""; // Reset the user name
    Get.offNamed('/login'); // Redirect to the login page
  }

  // Get the stored token (unchanged)
  Future<String?> getToken() async {
    return await _tokenStorageService.getToken();
  }

  Future<String?> getFullName() async {
    return await _userStorageService.getFullName();
  }

  Future<String?> getPhoneNumber() async {
    return await _userStorageService.getPhoneNumber();
  }
}
