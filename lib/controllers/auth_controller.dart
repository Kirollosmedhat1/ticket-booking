import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var canResendEmail = true.obs;
  var userName = "Guest".obs;

  Timer? _timer;
  final storage = GetStorage();

  final String baseUrl = "https://your-api-url.com/api"; // 🔥 Replace with actual API URL

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
  }

  /// 🔹 Login
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        storage.write("token", data["token"]);
        storage.write("userName", data["user"]["fullName"]);
        userName.value = data["user"]["fullName"];
        Get.snackbar("Success", "Logged in successfully!", backgroundColor: Colors.green);
        return true;
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error["message"] ?? "Login failed", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    isLoading.value = false;
    return false;
  }

  /// 🔹 Register
  Future<void> register(String email, String password, String fullName, String phone) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "fullName": fullName,
          "phone": phone,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Registered successfully! Please verify your email.", backgroundColor: Colors.green);
        startCooldown();
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error["message"] ?? "Registration failed", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }

  /// 🔹 Fetch user name from local storage
  void fetchUserName() {
    String? name = storage.read("userName");
    if (name != null) {
      userName.value = name;
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await storage.erase();
    Get.offAllNamed('/login');
  }

  /// 🔹 Resend verification email
  Future<void> resendVerificationEmail() async {
    if (!canResendEmail.value) return;
    isLoading.value = true;
    try {
      final token = storage.read("token");
      final response = await http.post(
        Uri.parse("$baseUrl/resend-verification"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Verification email sent again!", backgroundColor: Colors.green);
        startCooldown();
      } else {
        var error = jsonDecode(response.body);
        Get.snackbar("Error", error["message"] ?? "Failed", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }

  /// 🔹 Cooldown Timer
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
}
