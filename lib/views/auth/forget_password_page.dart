import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Step tracking: 0 = email, 1 = otp, 2 = password
  int currentStep = 0;
  String? resetToken; // Store the token from OTP verification

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final error = await authController.sendPasswordResetOTP(
          emailController.text.trim(),
        );
        if (error == null) {
          setState(() {
            currentStep = 1;
          });
          _showSnackBar("Success", "OTP sent to your email", Colors.green);
        } else {
          _showSnackBar("Error", error, Colors.red);
        }
      } catch (e) {
        _showSnackBar("Error", e.toString(), Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final (token, error) = await authController.verifyPasswordResetOTP(
          emailController.text.trim(),
          otpController.text.trim(),
        );
        if (error == null && token != null) {
          setState(() {
            currentStep = 2;
            resetToken = token; // Store the token for password change
          });
          _showSnackBar("Success", "OTP verified successfully", Colors.green);
        } else {
          _showSnackBar(
              "Error", error ?? "OTP verification failed", Colors.red);
        }
      } catch (e) {
        _showSnackBar("Error", e.toString(), Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        _showSnackBar("Error", "Passwords do not match", Colors.red);
        return;
      }
      if (resetToken == null) {
        _showSnackBar(
            "Error", "Session expired, please verify OTP again", Colors.red);
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        final error = await authController.changePassword(
          resetToken!,
          passwordController.text.trim(),
        );
        if (error == null) {
          _showSnackBar("Success", "Password reset successfully", Colors.green);
          Future.delayed(Duration(seconds: 2), () {
            Get.offNamed('/login');
          });
        } else {
          _showSnackBar("Error", error, Colors.red);
        }
      } catch (e) {
        _showSnackBar("Error", e.toString(), Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String title, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CustomLoadingIndicator(),
      color: Colors.black,
      opacity: 0.5,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Reset Password"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (currentStep > 0) {
                setState(() {
                  currentStep--;
                });
              } else {
                Get.back();
              }
            },
          ),
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signupbackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              SizedBox(height: screenHeight / 20),
              Center(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Step 1: Email Input
                        if (currentStep == 0) ...[
                          Text(
                            "Enter Your Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Text(
                            "We'll send you an OTP to reset your password",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.08),
                          CustomTextField(
                            controller: emailController,
                            labelText: "Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.15),
                          CustomButton(
                            text: "Send OTP",
                            textcolor: Colors.black,
                            bordercolor: Color(0xffDFA000),
                            backgroundcolor: Color(0xffDFA000),
                            onPressed: sendOTP,
                          ),
                        ],

                        // Step 2: OTP Input
                        if (currentStep == 1) ...[
                          Text(
                            "Enter OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Text(
                            "We sent a 6-digit code to ${emailController.text}",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.08),
                          CustomTextField(
                            controller: otpController,
                            labelText: "Enter OTP",
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "OTP is required";
                              }
                              if (value.length < 4) {
                                return "OTP must be at least 4 characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.15),
                          CustomButton(
                            text: "Verify OTP",
                            textcolor: Colors.black,
                            bordercolor: Color(0xffDFA000),
                            backgroundcolor: Color(0xffDFA000),
                            onPressed: verifyOTP,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          TextButton(
                            onPressed: sendOTP,
                            child: Text(
                              "Didn't receive OTP? Resend",
                              style: TextStyle(
                                color: Color(0xffDFA000),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],

                        // Step 3: Password Reset
                        if (currentStep == 2) ...[
                          Text(
                            "Create New Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Text(
                            "Enter a strong password to secure your account",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.08),
                          CustomTextField(
                            showEyeIcon: true,
                            controller: passwordController,
                            labelText: "New Password",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          CustomTextField(
                            showEyeIcon: true,
                            controller: confirmPasswordController,
                            labelText: "Confirm Password",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.15),
                          CustomButton(
                            text: "Reset Password",
                            textcolor: Colors.black,
                            bordercolor: Color(0xffDFA000),
                            backgroundcolor: Color(0xffDFA000),
                            onPressed: resetPassword,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
