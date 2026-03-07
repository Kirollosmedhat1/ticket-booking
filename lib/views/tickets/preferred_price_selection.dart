import 'package:darbelsalib/controllers/preferred_price_controller.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PreferredPriceSelectionPage extends StatelessWidget {
  final PreferredPriceController controller =
      Get.put(PreferredPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Price Selection")),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          progressIndicator: CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose your preferred price option for all tickets:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            Obx(() => RadioListTile<String>(
                  title: Text("Original Price (100%)",
                      style: TextStyle(color: Colors.white)),
                  value: 'original',
                  groupValue: controller.selectedOption.value,
                  onChanged: (value) => controller.setSelectedOption(value!),
                  activeColor: Color(0xffdfa000),
                )),
            Obx(() => RadioListTile<String>(
                  title: Text("50% of Original Price",
                      style: TextStyle(color: Colors.white)),
                  value: '50%',
                  groupValue: controller.selectedOption.value,
                  onChanged: (value) => controller.setSelectedOption(value!),
                  activeColor: Color(0xffdfa000),
                )),
            Obx(() => RadioListTile<String>(
                  title: Text("25% of Original Price",
                      style: TextStyle(color: Colors.white)),
                  value: '25%',
                  groupValue: controller.selectedOption.value,
                  onChanged: (value) => controller.setSelectedOption(value!),
                  activeColor: Color(0xffdfa000),
                )),
            Spacer(),
            Obx(() => Text(
                  "Total Price: ${controller.totalPrice.toStringAsFixed(2)} EGP",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/donate-seats');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffdfa000),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: GoBackText(
                text: "Back to Cart",
                // Navigate back to cart page
                onTap: () => Get.toNamed("/cart"),
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
