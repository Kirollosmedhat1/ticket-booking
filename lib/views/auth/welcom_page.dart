import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomPage extends StatelessWidget {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(screenhight * 0.04),
              child: Column(
                children: [
                  Container(
                    height: screenhight * 0.2,
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    height: screenhight * 0.5,
                    width: screenWidth * 0.6,
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
                    onPressed: ()  => Get.toNamed('/login'),
                  ),
                  SizedBox(height: screenhight * 0.025),
                  CustomButton(
                    textcolor: Colors.white,
                              bordercolor: Colors.white,
                              backgroundcolor: Colors.black,
                    text: "Sign up",
                    onPressed: ()  => Get.toNamed('/register'),
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
