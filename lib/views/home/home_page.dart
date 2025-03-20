// ignore_for_file: use_key_in_widget_constructors

import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/core/services/user_storage_service.dart';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/contact_us_section.dart';
import 'package:darbelsalib/views/widgets/current_service_poster.dart';
import 'package:darbelsalib/views/widgets/custom_appbar.dart';
import 'package:darbelsalib/views/widgets/home_page_section.dart';
import 'package:darbelsalib/views/widgets/image_viewer.dart';
import 'package:darbelsalib/views/widgets/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = Get.put(AuthController());
  final CartController cartController = Get.put(CartController());
  final UserStorageService userStorageService = UserStorageService();
  String userName = "";

  @override
  void initState() {
    super.initState();
    _checkToken();
    _getUserData();
  }

  void _checkToken() async {
    String? token = await authController.getToken();
    if (token == null) {
      // Navigate to the login page if no token is found
      Get.offAllNamed('/login');
    }
  }

  void _getUserData() async {
    authController.userName.value =
        await userStorageService.getFullName() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "",
          leading: false,
        ),
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
                    for (int number = 1; number <= 39; number++)
                      {'imgName': number.toString()}
                  ], hasSubtitles: false),
                ),
                HomePageSection(
                  title: "About Us",
                  content: Text(
                    "We are a passionate team from Saint George Agouza Church, dedicated to sharing the story of Christ's life, sacrifice, and resurrection through theater. Our plays, inspired by the Gospel, aim to inspire and deepen faith in our community. Through prayer and creativity, we bring the message of Christ's love to life, honoring His teachings and glorifying God. Join us as we celebrate His story and share His enduring hope with the world.\n\nTo God be the glory!",
                    style: TextStyle(
                      fontSize: ScreenSizeHandler.smaller * 0.0372,
                      color: const Color(0xFFF2F2F2),
                    ),
                  ),
                ),
                const HomePageSection(
                  title: "Contact Us",
                  content: ContactUsSection(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: //add a logout button
                      GestureDetector(
                    onTap: () {
                      authController.logout();
                      cartController.clearCart();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Color(0xffdfa000),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          "Logout",
                          style: TextStyle(
                              color: Color(0xffdfa000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
