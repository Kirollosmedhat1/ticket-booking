// ignore_for_file: use_key_in_widget_constructors

import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/core/services/database_service.dart';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/contact_us_section.dart';
import 'package:darbelsalib/views/widgets/current_service_poster.dart';
import 'package:darbelsalib/views/widgets/custom_appbar.dart';
import 'package:darbelsalib/views/widgets/home_page_section.dart';
import 'package:darbelsalib/views/widgets/image_viewer.dart';
import 'package:darbelsalib/views/widgets/my_tickets_button.dart';
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
        // Obx(() {
        //   return ticketController.seatsData.isEmpty
        //       ? const Center(child: CircularProgressIndicator())
        //       : SingleChildScrollView(
        //           // 🔥 Wraps the entire page to make it scrollable
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               // **Event Image**
        //               Center(
        //                 child: Container(
        //                   height: MediaQuery.of(context).size.width / 5,
        //                   width: MediaQuery.of(context).size.width / 5,
        //                   decoration: BoxDecoration(
        //                     image: DecorationImage(
        //                       image: AssetImage("assets/images/event.jpg"),
        //                       fit: BoxFit.contain,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(height: 10),

        //               // **Seat Layout (Scrollable)**
        //               InteractiveViewer(
        //                 panEnabled: true,
        //                 boundaryMargin: EdgeInsets.all(0),
        //                 minScale: 0.05,
        //                 maxScale: 4.0,
        //                 child: SingleChildScrollView(
        //                   scrollDirection: Axis.horizontal,
        //                   child: SizedBox(
        //                     width: MediaQuery.of(context).size.width *
        //                         2, // Adjust width to fit seats properly
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       crossAxisAlignment: CrossAxisAlignment.center,
        //                       children: [
        //                         // **First Section**
        //                         for (int row = 0; row < 10; row++)
        //                           Align(
        //                             alignment: Alignment.center,
        //                             child: Row(
        //                               mainAxisSize: MainAxisSize.min,
        //                               children: [
        //                                 for (int seat = 0; seat < 6 + row; seat++)
        //                                   _buildSeat(
        //                                       "F${String.fromCharCode(65 + row)}${seat + 1}"),
        //                                 SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.006),
        //                                 for (int seat = 0; seat < 13; seat++)
        //                                   _buildSeat(
        //                                       "F${String.fromCharCode(65 + row)}${6 + row + seat + 1}"),
        //                                 SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.006),
        //                                 for (int seat = 0; seat < 6 + row; seat++)
        //                                   _buildSeat(
        //                                       "F${String.fromCharCode(65 + row)}${6 + row + 13 + seat + 1}"),
        //                               ],
        //                             ),
        //                           ),
        //                         SizedBox(
        //                           height:
        //                               MediaQuery.of(context).size.width * 0.008,
        //                         ),

        //                         // **Second Section**
        //                         for (int row = 0; row < 8; row++)
        //                           Align(
        //                             alignment: Alignment.center,
        //                             child: Row(
        //                               mainAxisSize: MainAxisSize.min,
        //                               children: [
        //                                 for (int seat = 0; seat < 14; seat++)
        //                                   _buildSeat(
        //                                       "S${String.fromCharCode(65 + row)}${seat + 1}"),
        //                                 SizedBox(
        //                                   width:
        //                                       MediaQuery.of(context).size.width *
        //                                           0.006,
        //                                 ),
        //                                 for (int seat = 0; seat < 14; seat++)
        //                                   _buildSeat(
        //                                       "S${String.fromCharCode(65 + row)}${14 + seat + 1}"),
        //                                 SizedBox(
        //                                   width:
        //                                       MediaQuery.of(context).size.width *
        //                                           0.006,
        //                                 ),
        //                                 for (int seat = 0; seat < 14; seat++)
        //                                   _buildSeat(
        //                                       "S${String.fromCharCode(65 + row)}${28 + seat + 1}"),
        //                               ],
        //                             ),
        //                           ),
        //                         SizedBox(
        //                           height:
        //                               MediaQuery.of(context).size.width * 0.008,
        //                         ),

        //                         // **Balcony Section**
        //                         for (int row = 0; row < 5; row++)
        //                           Align(
        //                             alignment: Alignment.center,
        //                             child: Row(
        //                               mainAxisSize: MainAxisSize.min,
        //                               children: [
        //                                 for (int chamber = 0;
        //                                     chamber < 4;
        //                                     chamber++)
        //                                   Row(
        //                                     mainAxisSize: MainAxisSize.min,
        //                                     children: [
        //                                       for (int seat = 0;
        //                                           seat < 10;
        //                                           seat++)
        //                                         _buildSeat(
        //                                             "B${String.fromCharCode(65 + row)}${chamber * 10 + seat + 1}"),
        //                                       SizedBox(
        //                                         width: MediaQuery.of(context)
        //                                                 .size
        //                                                 .width *
        //                                             0.006,
        //                                       ),
        //                                     ],
        //                                   ),
        //                               ],
        //                             ),
        //                           ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        // }),
        );
  }

  // Widget _buildSeat(String seatNumber) {
  //   String status = ticketController.seatsData[seatNumber] ?? "available";

  //   return CustomSeat(
  //     seatNumber: seatNumber,
  //     status: status,
  //     onSeatSelected: ticketController.selectSeat,
  //   );
  // }
}
