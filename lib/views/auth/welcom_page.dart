import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomPage extends StatelessWidget {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;

    // Define a maximum width for the content
    final double maxWidth = 500.0; // Adjust this value as needed

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: maxWidth), // Add max width constraint
              padding: EdgeInsets.all(screenhight * 0.04),
              child: Column(
                children: [
                  Container(
                    height: ScreenSizeHandler.smaller * 0.3,
                    width: ScreenSizeHandler.smaller * 0.7,
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    height: ScreenSizeHandler.smaller * 0.75,
                    width: ScreenSizeHandler.smaller * 0.53,
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage("assets/images/Welcome_img.png"),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(height: screenhight * 0.04),
                  CustomButton(
                    textcolor: Colors.black,
                    bordercolor: Color(0xffDFA000),
                    backgroundcolor: Color(0xffDFA000),
                    text: "Login",
                    onPressed: () => Get.toNamed('/login'),
                  ),
                  SizedBox(height: screenhight * 0.025),
                  CustomButton(
                    textcolor: Colors.white,
                    bordercolor: Colors.white,
                    backgroundcolor: Colors.black,
                    text: "Sign up",
                    onPressed: () => Get.toNamed('/register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
