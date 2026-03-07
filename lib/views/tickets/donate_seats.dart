import 'package:darbelsalib/controllers/donate_seats_controller.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DonateSeatsPage extends StatelessWidget {
  final DonateSeatsController controller = Get.put(DonateSeatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donate Extra Seats")),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          progressIndicator: CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Would you like to donate extra seats for someone else?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "Each extra seat costs 200 EGP and helps provide tickets for those who cannot afford them.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 40),
            Text(
              "Number of Extra Seats:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => controller.decrementSeats(),
                  icon: Icon(Icons.remove_circle, color: Color(0xffdfa000), size: 32),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffdfa000), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => Text(
                        "${controller.extraSeats.value}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () => controller.incrementSeats(),
                  icon: Icon(Icons.add_circle, color: Color(0xffdfa000), size: 32),
                ),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                "Seats",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70),
              ),
            ),
            SizedBox(height: 40),
            Obx(() => Text(
                  "Total Price: ${controller.totalPrice.toStringAsFixed(2)} EGP",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
            SizedBox(height: 16),
            Obx(() => controller.extraSeats.value > 0
                ? Text(
                    "Including ${controller.extraSeats.value} extra seat${controller.extraSeats.value == 1 ? '' : 's'} at 200 EGP each",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  )
                : Container()),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                await controller.processCheckout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffdfa000),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Checkout",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: GoBackText(
                text: "Back to Price Selection",
                onTap: () => Get.toNamed("/preferred-price-selection"),
              ),
            ),
          ],
        ),
        ),
        );
      }),
    );
  }
}