import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/views/widgets/book_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading = true,
  });

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    CartController cartController = Get.put(CartController());
    return AppBar(
      automaticallyImplyLeading: leading,
      backgroundColor: Colors.black,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: //add a logout button
            GestureDetector(
          onTap: () {
            authController.logout();
            cartController.clearCart();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: Color(0xffdfa000),
              ),
              const SizedBox(height: 2),
              const Text(
                "Logout",
                style: TextStyle(color: Color(0xffdfa000), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => Get.toNamed("/mytickets"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ticket-2.png',
                  width: 24,
                  height: 24,
                  color: Colors.white, // Optional: tint white
                ),
                const SizedBox(height: 2),
                const Text(
                  "My tickets",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => Get.toNamed("/cart"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/cart_icon.png',
                  width: 24,
                  height: 24,
                  color: Colors.white, // Optional: tint white
                ),
                const SizedBox(height: 2),
                const Text(
                  "Cart",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
