import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/utils/validators.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/custom_text_button.dart';
import 'package:darbelsalib/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
 final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  Future<void> register() async {
  try {
    final user = await authController.registerWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
      fullNameController.text.trim(),
      phoneController.text.trim(),
    );
    if (user != null) {
      Get.offNamed('/home');
    }
  } catch (e) {
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
  }
}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: Container(
        width: screenWidth,
        height: screenhight,
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
                            controller: fullNameController,
                            labelText: "Full Name",
                            validator: Validators.validateName,
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
                            controller: passwordController,
                            labelText: "Password",
                            validator: Validators.validatePassword,
                            obscureText: true,
                          ),
                          SizedBox(height: screenhight * 0.1),
                          Container(
                            height: screenhight * 0.1,
                            width: screenWidth * 0.3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.cover)),
                          ),
                          CustomButton(
                              text: "Signup",
                              textcolor: Colors.black,
                              bordercolor: Color(0xffDFA000),
                              backgroundcolor: Color(0xffDFA000),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await register();
                                }
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: screenhight / 60),
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
    );
  }
}