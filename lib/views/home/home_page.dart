// ignore_for_file: use_key_in_widget_constructors

import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/services/database_service.dart';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/contact_us_section.dart';
import 'package:darbelsalib/views/widgets/current_service_poster.dart';
import 'package:darbelsalib/views/widgets/custom_appbar.dart';
import 'package:darbelsalib/views/widgets/home_page_section.dart';
import 'package:darbelsalib/views/widgets/image_viewer.dart';
import 'package:darbelsalib/views/widgets/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: ""),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSizeHandler.smaller * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: ScreenSizeHandler.smaller * 0.37,
                    width: ScreenSizeHandler.smaller * 0.657,
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Obx(() => WelcomeText(name: authController.userName.value)),
                const HomePageSection(
                  title: "Current Service",
                  content: Center(child: CurrentServicePoster()),
                ),
                HomePageSection(
                  title: "Past Services",
                  content: ImageViewer(images: [
                    for (int year = 2012; year <= 2024; year++)
                      if (year != 2020 && year != 2021)
                        {'imgName': year.toString()}
                  ], hasSubtitles: true),
                ),
                HomePageSection(
                  title: "Photo Gallery",
                  content: ImageViewer(images: [
                    for (int year = 2012; year <= 2024; year++)
                      if (year != 2020 && year != 2021)
                        {'imgName': year.toString()}
                  ], hasSubtitles: false),
                ),
                HomePageSection(
                  title: "About Us",
                  content: Text(
                    "We are an amazing team that does amazing things",
                    style: TextStyle(
                      fontSize: ScreenSizeHandler.smaller * 0.0372,
                      color: const Color(0xFFF2F2F2),
                    ),
                  ),
                ),
                const HomePageSection(
                  title: "Contact Us",
                  content: ContactUsSection(),
                )
              ],
            ),
          ),
        )
        );
  }
}
