import 'dart:convert';

import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/core/services/user_storage_service.dart';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart'; 
import 'package:web/web.dart' as web;

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final UserStorageService _userStorageService = UserStorageService();
  final ApiService _apiService = ApiService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final RxBool _isLoading = false.obs;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _tokenStorageService.getToken();
    debugPrint('[DonationPage] _checkLoginStatus: token exists=${token != null && token.isNotEmpty}');
    if (mounted) {
      setState(() => _isLoggedIn = token != null && token.isNotEmpty);
      debugPrint('[DonationPage] _isLoggedIn=$_isLoggedIn');
    }
  }

  static const String _messageEn =
      'Darb El Salib delivers a powerful message to everyone… Our goal is to advance the ministry in the best way possible and with the lowest ticket price, so it can have the greatest impact on hearts.If you would like to be part of supporting the ministry, you can donate any amount.';

  static const String _messageAr =
      "درب الصليب بيقدم رساله قويه للجميع ... هدفنا الخدمه تتقدم باحس شكل و بأقل سعر للتذكره علشان يكون ليها اقوى تأثير فى النفوس.إذا كنت عايز تكون من المشاركين فى دعم الخدمه ممكن تتبرع بأى مبلغ.";

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffDFA000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffDFA000), width: 2),
        ),
      );

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _proceedToPayment() async {
    debugPrint('[DonationPage] _proceedToPayment called');
    final amountText = _amountController.text.trim();
    debugPrint('[DonationPage] amountText="$amountText"');

    if (amountText.isEmpty) {
      Get.snackbar('Notice', 'Please enter an amount',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final amount = num.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar('Notice', 'Please enter a valid amount',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final token = await _tokenStorageService.getToken();

    String name;
    String email;
    String mobile;

    if (_isLoggedIn) {
      name = (await _userStorageService.getFullName()) ?? '';
      email = (await _userStorageService.getEmail()) ?? '';
      mobile = (await _userStorageService.getPhoneNumber()) ?? '';
      debugPrint('[DonationPage] Using UserStorageService: name="$name", email="$email", mobile="$mobile"');
    } else {
      name = _nameController.text.trim();
      email = _emailController.text.trim();
      mobile = _mobileController.text.trim();
      if (name.isEmpty) {
        Get.snackbar('Notice', 'Please enter your name',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (email.isEmpty) {
        Get.snackbar('Notice', 'Please enter your email',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (mobile.isEmpty) {
        Get.snackbar('Notice', 'Please enter your mobile number',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      debugPrint('[DonationPage] Using form fields: name="$name", email="$email", mobile="$mobile"');
    }

    debugPrint('[DonationPage] Calling API: amount=$amount, name="$name", email="$email", mobile="$mobile"');
    _isLoading.value = true;
    try {
      final response = await _apiService.requestDonationPayment(
        token,
        amount: amount,
        name: name,
        email: email,
        mobile: mobile,
      );

      debugPrint('[DonationPage] API response: statusCode=${response.statusCode}, body=${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final paymentUrl = data['url'] as String?;
        debugPrint('[DonationPage] paymentUrl=$paymentUrl');
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          final uri = Uri.parse(paymentUrl);
          web.window.location.href = uri.toString();
        } else {
          Get.snackbar('Error', 'Payment URL not received',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to request payment',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e, stackTrace) {
      debugPrint('[DonationPage] Error: $e');
      debugPrint('[DonationPage] StackTrace: $stackTrace');
      Get.snackbar('Error', 'An error occurred. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const maxWidth = 500.0;
    const textStyle = TextStyle(color: Colors.white, fontSize: 18);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Donate | تبرع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: _isLoading.value,
          progressIndicator: const CircularProgressIndicator(
            color: Color(0xffDFA000),
          ),
          color: Colors.black,
          opacity: 0.5,
          child: ListView(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  padding: EdgeInsets.all(ScreenSizeHandler.smaller * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // English message
                      Text(
                        _messageEn,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenSizeHandler.smaller * 0.038,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: ScreenSizeHandler.smaller * 0.04),
                      // Arabic message
                      Text(
                        _messageAr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenSizeHandler.smaller * 0.038,
                          height: 1.6,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: ScreenSizeHandler.smaller * 0.05),
                      _buildLabel('Amount (EGP) / المبلغ (جنيه مصري)'),
                      TextField(
                        controller: _amountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        style: textStyle,
                        decoration: _inputDecoration('Enter amount'),
                      ),
                      if (!_isLoggedIn) ...[
                        SizedBox(height: ScreenSizeHandler.smaller * 0.03),
                        _buildLabel('Name / الاسم'),
                        TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          style: textStyle,
                          decoration: _inputDecoration('Enter your name'),
                        ),
                        SizedBox(height: ScreenSizeHandler.smaller * 0.03),
                        _buildLabel('Email / البريد الإلكتروني'),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: textStyle,
                          decoration: _inputDecoration('Enter your email'),
                        ),
                        SizedBox(height: ScreenSizeHandler.smaller * 0.03),
                        _buildLabel('Mobile / رقم الموبايل'),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          style: textStyle,
                          decoration:
                              _inputDecoration('e.g. +201234567890'),
                        ),
                      ],
                      SizedBox(height: ScreenSizeHandler.smaller * 0.05),
                      CustomButton(
                        textcolor: Colors.black,
                        bordercolor: const Color(0xffDFA000),
                        backgroundcolor: const Color(0xffDFA000),
                        text: 'Proceed to Payment',
                        onPressed: _proceedToPayment,
                      ),
                      SizedBox(height: ScreenSizeHandler.smaller * 0.03),
                      Center(
                        child:GoBackText(
                        text: 'Go Back',
                        onTap: () => Get.toNamed('/home'),
                      ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenSizeHandler.smaller * 0.015),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: ScreenSizeHandler.smaller * 0.038,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
