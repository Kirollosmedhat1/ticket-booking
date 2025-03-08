import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/utils/validators.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 30),
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.height / 1.7,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              CustomButton(
                text: "Login",
                onPressed: () async {
                  String? emailError = Validators.validateEmail(emailController.text.trim());
                  String? passwordError = Validators.validatePassword(passwordController.text.trim());
                  if (emailError == null && passwordError == null) {
                    bool success = await authController.login(emailController.text.trim(), passwordController.text.trim());
                    if (success) {
                      Get.offNamed('/home');
                    }
                  } else {
                    Get.snackbar("Error", "${emailError ?? ''} ${passwordError ?? ''}".trim(), backgroundColor: Colors.red);
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              TextButton(
                onPressed: () async {
                  String? emailError = Validators.validateEmail(emailController.text.trim());
                  if (emailError == null) {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

                    Get.snackbar("Success", "Password reset email sent!", backgroundColor: Colors.green);
                  } else {
                    Get.snackbar("Error", emailError, backgroundColor: Colors.red);
                  }
                },
                child: Text("Forgot Password?"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              TextButton(
                onPressed: () => Get.offNamed('/register'),
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
