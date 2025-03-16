// ignore_for_file: prefer_const_constructors

import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_button.dart';
import 'package:darbelsalib/views/widgets/storylinr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentServicePage extends StatelessWidget {
  const CurrentServicePage({super.key});

  bool isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Service"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: ScreenSizeHandler.smaller * 0.05,
          ),
          Container(
            height: ScreenSizeHandler.smaller * 1.02 >= 442
                ? 442
                : ScreenSizeHandler.smaller * 1.02,
            width: ScreenSizeHandler.smaller * 1 >= 430
                ? 430
                : ScreenSizeHandler.smaller * 1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    ScreenSizeHandler.screenWidth * 0.03), // Rounded corners
                image: DecorationImage(
                    image: const AssetImage(
                        "assets/images/currentservicepage.png"),
                    fit: BoxFit.fill)),
          ),
          Container(
            padding: EdgeInsets.all(
              ScreenSizeHandler.screenHeight * 0.02,
            ),
            child: Column(
              children: [
                Storyline(),
                SizedBox(
                  height: ScreenSizeHandler.screenWidth * 0.03,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenSizeHandler.screenWidth * 0.5),
                  height: ScreenSizeHandler.smaller * 0.195,
                  width: ScreenSizeHandler.smaller * 0.3465,
                  decoration: BoxDecoration(
                      // color: Colors.amber,
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.contain)),
                ),
                CustomButton(
                    text: "Book your seat",
                    textcolor: Colors.black,
                    bordercolor: Color(0xffDFA000),
                    backgroundcolor: Color(0xffDFA000),
                    onPressed: () {
                      if (isLoggedIn()) {
                        Get.toNamed("/selectsection");
                      } else {
                        Get.toNamed("/register");
                      }
                    }),
                SizedBox(
                  height: ScreenSizeHandler.screenWidth * 0.15,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
