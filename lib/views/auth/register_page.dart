import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/utils/validators.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/custom_text_button.dart';
import 'package:darbelsalib/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController(); // Add this
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); // Dispose the confirm password controller
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final message = await authController.registerWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        phoneController.text.trim(),
      );
      if (message != null) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Registration",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black,
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Color(0xffDFA000)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                e.toString(),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: Color(0xffDFA000)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
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
          title: Text("Sign up"),
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
                              controller: firstNameController,
                              labelText: "First Name",
                              validator: (value) => Validators.validateNotEmpty(
                                  value, "First Name"),
                            ),
                            CustomTextField(
                              controller: lastNameController,
                              labelText: "Last Name",
                              validator: (value) => Validators.validateNotEmpty(
                                  value, "Last Name"),
                            ),
                            CustomTextField(
                              controller: emailController,
                              labelText: "Email",
                              validator: Validators.validateEmail,
                            ),
                            CustomTextField(
                              controller: phoneController,
                              labelText: "Phone Number",
                              validator: Validators.validatePhone,
                              keyboardType: TextInputType.phone,
                            ),
                            CustomTextField(
                              showEyeIcon: true,
                              controller: passwordController,
                              labelText: "Password",
                              validator: Validators.validatePassword,
                              obscureText: true,
                            ),
                            // Add the confirm password field
                            CustomTextField(
                              showEyeIcon: true,
                              controller: confirmPasswordController,
                              labelText: "Confirm Password",
                              validator: (value) => Validators.validateConfirmPassword(
                                value,
                                passwordController.text, // Pass the original password
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: screenHeight * 0.1),
                            CustomButton(
                              text: "Signup",
                              textcolor: Colors.black,
                              bordercolor: Color(0xffDFA000),
                              backgroundcolor: Color(0xffDFA000),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await register();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight / 60),
                      CustomTextButton(
                        text: "Already have an account? Login",
                        onPressed: () => Get.offNamed('/login'),
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