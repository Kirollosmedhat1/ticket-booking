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

 Future<UserModel?> registerWithEmail(
    String email, String password, String firstName, String lastName, String phone) async {
  try {
    final UserModel? user = await _authService.registerWithEmail(
        email, password, firstName, lastName, phone);
    if (user != null) {
      userName.value = user.fullName;
      await _tokenStorageService.saveToken(user.token);
      await _userStorageService.saveFullName(user.fullName);
      await _userStorageService.savePhoneNumber(user.phone);
      await _userStorageService.saveEmail(user.email);
      Get.snackbar("Success", "User registered successfully",
          backgroundColor: Colors.green);
      return user;
    } else {
      Get.snackbar("Error", "Failed to register", backgroundColor: Colors.red);
      return null;
    }
  } catch (e) {
    print("Registration Error: $e"); // Log the error
    if (e.toString().contains("email already exists")) {
      Get.snackbar("Error", "A User with this Email Already Exists",
          backgroundColor: Colors.red);
    } else if (e.toString().contains("Invalid API response")) {
      Get.snackbar("Error", "Invalid response from the server. Please try again.",
          backgroundColor: Colors.red);
    } else {
      Get.snackbar("Error", "Registration failed: ${e.toString()}",
          backgroundColor: Colors.red);
    }
    return null;
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
        Get.snackbar("Success", "Logged in successfully",
            backgroundColor: Colors.green);
        return user;
      } else {
        Get.snackbar("Error", "Failed to login", backgroundColor: Colors.red);
        return null;
      }
    } catch (e) {
      if (e.toString().contains("Invalid credentials")) {
        Get.snackbar("Error", "Invalid email or password",
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
      }
      return null;
    }
  }

  /// **🔹 Send Email Verification**
  Future<void> sendEmailVerification(String email) async {
    try {
      await _authService.sendEmailVerification(email);
      Get.snackbar("Success", "Email verification sent",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
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
}
