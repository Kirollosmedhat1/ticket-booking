import 'package:darbelsalib/controllers/preferred_price_controller.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PreferredPriceSelectionPage extends StatefulWidget {
  const PreferredPriceSelectionPage({Key? key}) : super(key: key);

  @override
  State<PreferredPriceSelectionPage> createState() =>
      _PreferredPriceSelectionPageState();
}

class _PreferredPriceSelectionPageState
    extends State<PreferredPriceSelectionPage> {
  final PreferredPriceController controller =
      Get.put(PreferredPriceController());

  @override
  void initState() {
    super.initState();
    // Ensure price is initialized on page creation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notice | تنبيه")),
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
                  "The original ticket price is 200 EGP, but we don’t want the cost to prevent anyone from attending the service.\nYou can pay any amount according to your ability.\n",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  "السعر الأصلي للتذكرة 200 جنيه مصري، لكن مش عايزين التكلفة تكون سبب في منع أي شخص من حضور الخدمة.\nتقدر تدفع اى مبلغ حسب قدرتك. اختار من الاختيارات الاتيه للدفع.",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 50),
                Obx(() => RadioListTile<String>(
                      title: Text("200 EGP per ticket",
                          style: TextStyle(color: Colors.white)),
                      value: 'price_200',
                      groupValue: controller.selectedOption.value,
                      onChanged: (value) =>
                          controller.setSelectedOption(value!),
                      activeColor: Color(0xffdfa000),
                    )),
                Obx(() => RadioListTile<String>(
                      title: Text("100 EGP per ticket",
                          style: TextStyle(color: Colors.white)),
                      value: 'price_100',
                      groupValue: controller.selectedOption.value,
                      onChanged: (value) =>
                          controller.setSelectedOption(value!),
                      activeColor: Color(0xffdfa000),
                    )),
                Obx(() => RadioListTile<String>(
                      title: Text("75 EGP per ticket",
                          style: TextStyle(color: Colors.white)),
                      value: 'price_75',
                      groupValue: controller.selectedOption.value,
                      onChanged: (value) =>
                          controller.setSelectedOption(value!),
                      activeColor: Color(0xffdfa000),
                    )),
                Spacer(),
                Obx(() => Text(
                      "Total Price: ${controller.displayPrice.toStringAsFixed(2)} EGP",
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
