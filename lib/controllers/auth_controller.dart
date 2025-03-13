import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darbelsalib/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var canResendEmail = true.obs;
  var isPhoneVerified = false.obs;
  var userName = "Guest".obs; // 🔹 Store user's name dynamically
  Timer? _timer;
  String? verificationId;

  @override
  void onInit() {
    super.onInit();
    _fetchUserName(); // 🔹 Fetch user name on controller initialization
  }
  /// **🔹 Register User**
  
  Future<void> register(String email, String password, String fullName, String phone) async {
    isLoading.value = true;
    try {
      User? user = await _authService.registerWithEmail(email, password, fullName, phone);
      if (user != null) {
        startCooldown();
        Get.snackbar("Success", "Verification email sent! Please check your inbox.", backgroundColor: Colors.green);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }
   /// **🔹 Fetch User Name from Firestore**
  Future<void> _fetchUserName() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        userName.value = userDoc['fullName'] ?? "Guest"; // 🔹 Update name
      }
    }
  }


  /// **🔹 Send Email Verification Again (Cooldown)**
  Future<void> resendVerificationEmail() async {
    if (!canResendEmail.value) return; // Prevent spam clicks

    User? user = _authService.getCurrentUser();
    if (user != null && !user.emailVerified) {
      await _authService.sendEmailVerification(user);
      startCooldown();
      Get.snackbar("Success", "Verification email sent again!", backgroundColor: Colors.green);
    }
  }

  /// **🔹 Start Cooldown Timer**
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

  /// **🔹 Login User**
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      User? user = await _authService.loginWithEmail(email, password);
      if (user != null) {
        Get.snackbar("Success", "Logged in successfully!");
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    isLoading.value = false;
    return false;
  }

  /// **🔹 Logout User**
  Future<void> logout() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Logout Failed", "Something went wrong. Please try again.");
    }
  }

  /// **🔹 Request Phone Verification (OTP)**
  Future<void> sendPhoneVerification(String phoneNumber) async {
    try {
      await _authService.verifyPhoneNumber(phoneNumber, (verificationId, resendToken) {
        this.verificationId = verificationId;
        Get.snackbar("Success", "OTP sent to $phoneNumber", backgroundColor: Colors.green);
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to send OTP: $e", backgroundColor: Colors.red);
    }
  }

  /// **🔹 Confirm OTP Code**
  Future<void> verifyOtp(String otp) async {
    if (verificationId == null) {
      Get.snackbar("Error", "No verification request found!", backgroundColor: Colors.red);
      return;
    }
    try {
      await _authService.confirmOtpCode(verificationId!, otp);
      isPhoneVerified.value = true;
      Get.snackbar("Success", "Phone verified successfully!", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP: $e", backgroundColor: Colors.red);
    }
  }
}
