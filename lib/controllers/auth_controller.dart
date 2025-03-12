import 'dart:async';
import 'package:darbelsalib/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var canResendEmail = true.obs;
  Timer? _timer;

  // Register and send verification email
  Future<void> register(String email, String password, String fullName , String phone) async {
    isLoading.value = true;
    try {
      User? user = await _authService.registerWithEmail(email, password, fullName, phone);
      if (user != null) {
        startCooldown();
        Get.snackbar("Success", "Verification email sent! Please check your inbox.",
            backgroundColor: Colors.green);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }

  // Resend verification email with cooldown
  Future<void> resendVerificationEmail() async {
    if (!canResendEmail.value) return; // Prevent multiple taps

    User? user = _authService.getCurrentUser();
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      startCooldown();
      Get.snackbar("Success", "Verification email sent again!", backgroundColor: Colors.green);
    }
  }

  // Start cooldown to prevent spamming
  void startCooldown() {
    canResendEmail.value = false;
    _timer?.cancel();
    _timer = Timer(Duration(minutes: 1), () {
      canResendEmail.value = true;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Login only if email is verified
  Future<bool> login(String email, String password) async {
  isLoading.value = true;
  try {
    User? user = await _authService.loginWithEmail(email, password);
    if (user != null) {
      Get.snackbar("Success", "Logged in successfully!");
      isLoading.value = false;
      return true; // Login successful
    }
  } catch (e) {
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
  }
  isLoading.value = false;
  return false; // Login failed
}

// Reset password using Firebase reset link
Future<void> resetPassword(String oobCode, String newPassword) async {
  try {
    await FirebaseAuth.instance.confirmPasswordReset(
      code: oobCode,
      newPassword: newPassword,
    );
    Get.snackbar("Success", "Password has been reset successfully!", backgroundColor: Colors.green);
    Get.offNamed('/login'); // Navigate back to login after success
  } catch (e) {
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
  }
}




  // Logout user
  Future<void> logout() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/login'); // Navigate to login page after logout
    } catch (e) {
      Get.snackbar("Logout Failed", "Something went wrong. Please try again.");
    }
  }

}
