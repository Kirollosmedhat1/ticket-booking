import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/utils/validators.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        titleTextStyle: TextStyle(fontSize: screenWidth * 0.017,),
      ),
      body:Center(
        child: Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:EdgeInsets.all(MediaQuery.of(context).size.height / 20,) ,
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 1.3,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _formKey, // Attach form key
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
                          controller: passwordController,
                          labelText: "Password",
                          validator: Validators.validatePassword,
                          obscureText: true,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 20),
                        CustomButton(
                          text: "Register",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authController.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                fullNameController.text.trim(),
                              );
                            }
                          },
                        ),
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 60),
                        Obx(() => TextButton(
                              onPressed: authController.canResendEmail.value
                                  ? authController.resendVerificationEmail
                                  : null,
                              child: Text(authController.canResendEmail.value
                                  ? "Resend Verification Email"
                                  : "Wait 1 min to resend"),
                            )),
                        SizedBox(height: MediaQuery.of(context).size.height / 60),
                        TextButton(
                          onPressed: () => Get.offNamed('/login'),
                          child: Text("Already have an account? Login"),
                        ),
              ],
            ),
        ),
      ),
    );
  }
}
