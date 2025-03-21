import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/custom_text_button.dart';
import 'package:darbelsalib/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authController.loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        Get.offNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
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
          automaticallyImplyLeading: false,
          title: Text("Login"),
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
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              labelText: "Email",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              showEyeIcon: true,
                              controller: passwordController,
                              labelText: "Password",
                              obscureText: true,
                            ),
                            SizedBox(height: screenHeight * 0.1),
                            CustomButton(
                              text: "Login",
                              textcolor: Colors.black,
                              bordercolor: Color(0xffDFA000),
                              backgroundcolor: Color(0xffDFA000),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await login();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight / 60),
                      CustomTextButton(
                        text: "Don't have an account? Sign up",
                        onPressed: () => Get.offNamed('/register'),
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
}
