// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/utils/validators.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/custom_text_button.dart';
import 'package:darbelsalib/views/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to send a POST request to the login endpoint
  Future<void> login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  final user = await authController.loginWithEmail(email, password);
  if (user != null) {
    // Login successful, navigate to home
    Get.offNamed('/home');
  }
  // Else, error snackbar is already handled inside loginWithEmail()
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenhight,
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signupbackground.jpg"),
            fit: BoxFit.contain,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: screenhight / 20),
            Center(
              child: Column(
                children: [
                  CustomTextField(
                    controller: emailController,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    labelText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: screenhight * 0.3),
                  Container(
                    height: screenhight * 0.1,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover)),
                  ),
                  CustomButton(
                    textcolor: Colors.black,
                    bordercolor: Color(0xffDFA000),
                    backgroundcolor: Color(0xffDFA000),
                    text: "Login",
                    onPressed: () async {
                      String? emailError = Validators.validateEmail(
                          emailController.text.trim());
                      String? passwordError = Validators.validatePassword(
                          passwordController.text.trim());
                      if (emailError == null && passwordError == null) {
                        await login();
                      } else {
                        Get.snackbar(
                            "Error",
                            "${emailError ?? ''} ${passwordError ?? ''}"
                                .trim(),
                            backgroundColor: Colors.red);
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                  CustomTextButton(
                    text: "Forgot Password?",
                    onPressed: () async {
                      String? emailError = Validators.validateEmail(
                          emailController.text.trim());
                      if (emailError == null) {
                        await authController
                            .forgotPassword(emailController.text.trim());
                      } else {
                        Get.snackbar("Error", emailError,
                            backgroundColor: Colors.red);
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                  CustomTextButton(
                    text: "Don't have an account? Register",
                    onPressed: () => Get.offNamed('/register'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}