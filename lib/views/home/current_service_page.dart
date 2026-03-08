// ignore_for_file: prefer_const_constructors

import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_appbar.dart';
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
    final posterAspectRatio = 530 / 542;
    final posterWidth = ScreenSizeHandler.smaller * 0.95;
    final posterHeight = (posterWidth / posterAspectRatio)
        .clamp(0.0, ScreenSizeHandler.smaller * 0.6);

    return Scaffold(
      appBar: CustomAppBar(title: "Current Service"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ScreenSizeHandler.smaller * 0.02),
            Container(
              constraints: BoxConstraints(
                maxHeight: posterHeight,
                maxWidth: posterWidth,
              ),
              height: posterHeight,
              width: posterWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ScreenSizeHandler.screenWidth * 0.03,
                ),
                image: const DecorationImage(
                  image: AssetImage("assets/images/currentservicepage.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(ScreenSizeHandler.screenHeight * 0.02),
              child: Column(
                children: [
                  Storyline(),
                  SizedBox(height: ScreenSizeHandler.screenWidth * 0.03),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenSizeHandler.screenHeight * 0.02,
                    ),
                    height: ScreenSizeHandler.smaller * 0.18,
                    width: ScreenSizeHandler.smaller * 0.32,
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
                    onPressed: () => Get.toNamed("/preferred-price-selection"),
                  ),
                  SizedBox(height: ScreenSizeHandler.screenHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
