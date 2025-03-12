import 'package:darbelsalib/views/widgets/custom_seat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/ticket_controller.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  final TicketController ticketController =
      Get.put(TicketController()); // Get the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed('/tickets'),
            child: Text("My Tickets", style: TextStyle(color: Colors.black)),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/cart'),
            icon: Icon(Icons.shopping_cart),
          ),
          CustomButton(
            textcolor: Colors.black,
                              bordercolor: Color(0xffDFA000),
                              backgroundcolor: Color(0xffDFA000),
            text: "Logout",
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: Obx(() {
        return ticketController.seatsData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                // 🔥 Wraps the entire page to make it scrollable
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // **Event Image**
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/event.jpg"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // **Seat Layout (Scrollable)**
                    InteractiveViewer(
                      panEnabled: true,
                      boundaryMargin: EdgeInsets.all(0),
                      minScale: 0.05,
                      maxScale: 4.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 2, // Adjust width to fit seats properly
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // **First Section**
                              for (int row = 0; row < 10; row++)
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int seat = 0; seat < 6 + row; seat++)
                                        _buildSeat(
                                            "F${String.fromCharCode(65 + row)}${seat + 1}"),
                                      SizedBox(width: MediaQuery.of(context).size.width  * 0.006),
                                      for (int seat = 0; seat < 13; seat++)
                                        _buildSeat(
                                            "F${String.fromCharCode(65 + row)}${6 + row + seat + 1}"),
                                      SizedBox(width: MediaQuery.of(context).size.width  * 0.006),
                                      for (int seat = 0; seat < 6 + row; seat++)
                                        _buildSeat(
                                            "F${String.fromCharCode(65 + row)}${6 + row + 13 + seat + 1}"),
                                    ],
                                  ),
                                ),
                              SizedBox(height: MediaQuery.of(context).size.width  * 0.008,),

                              // **Second Section**
                              for (int row = 0; row < 8; row++)
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int seat = 0; seat < 14; seat++)
                                        _buildSeat(
                                            "S${String.fromCharCode(65 + row)}${seat + 1}"),
                                      SizedBox(width: MediaQuery.of(context).size.width  * 0.006,),
                                      for (int seat = 0; seat < 14; seat++)
                                        _buildSeat(
                                            "S${String.fromCharCode(65 + row)}${14 + seat + 1}"),
                                      SizedBox(width: MediaQuery.of(context).size.width  * 0.006,),
                                      for (int seat = 0; seat < 14; seat++)
                                        _buildSeat(
                                            "S${String.fromCharCode(65 + row)}${28 + seat + 1}"),
                                    ],
                                  ),
                                ),
                              SizedBox(height: MediaQuery.of(context).size.width  * 0.008,),

                              // **Balcony Section**
                              for (int row = 0; row < 5; row++)
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int chamber = 0;
                                          chamber < 4;
                                          chamber++)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (int seat = 0;
                                                seat < 10;
                                                seat++)
                                              _buildSeat(
                                                  "B${String.fromCharCode(65 + row)}${chamber * 10 + seat + 1}"),
                                            SizedBox(width: MediaQuery.of(context).size.width  * 0.006,),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  /// **Build Individual Seat Widget**
  Widget _buildSeat(String seatNumber) {
    String status = ticketController.seatsData[seatNumber] ?? "available";

    return CustomSeat(
      seatNumber: seatNumber,
      status: status,
      onSeatSelected: ticketController.selectSeat,
    );
  }
}
