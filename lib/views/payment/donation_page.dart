import 'dart:convert';

import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final ApiService _apiService = ApiService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final RxBool _isLoading = false.obs;

  static const String _messageEn =
      'If you would like to support this mission beyond purchasing a ticket, '
      'you can make a donation. Every contribution helps us continue producing '
      'performances that spread hope, faith, and love.\n\n'
      'Your support truly makes a difference. ❤️';

  static const String _messageAr =
      'إذا كنت ترغب في دعم هذه الرسالة بما يتجاوز شراء تذكرة، يمكنك التبرع. '
      'كل مساهمة تساعدنا على الاستمرار في إنتاج عروض تنشر الأمل والإيمان والمحبة.\n\n'
      'دعمك يحدث فرقاً حقيقياً. ❤️';

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
    final amountText = _amountController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();

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

    final token = await _tokenStorageService.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Notice', 'Please log in first',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    _isLoading.value = true;
    try {
      final response = await _apiService.requestDonationPayment(
        token,
        amount: amount,
        name: name,
        email: email,
        mobile: mobile,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final paymentUrl = data['url'] as String?;
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          final uri = Uri.parse(paymentUrl);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar('Error', 'Payment URL not received',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to request payment',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
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
                      SizedBox(height: ScreenSizeHandler.smaller * 0.05),
                      CustomButton(
                        textcolor: Colors.black,
                        bordercolor: const Color(0xffDFA000),
                        backgroundcolor: const Color(0xffDFA000),
                        text: 'Proceed to EasyCash Payment',
                        onPressed: _proceedToPayment,
                      ),
                      SizedBox(height: ScreenSizeHandler.smaller * 0.03),
                      GoBackText(
                        text: 'Go Back',
                        onTap: () => Get.back(),
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
