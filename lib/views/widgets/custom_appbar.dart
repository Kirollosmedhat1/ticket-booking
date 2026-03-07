import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  Widget _buildDonationButton(BuildContext context) {
    final iconSize = (ScreenSizeHandler.smaller * 0.04).clamp(20.0, 28.0);
    final fontSize = (ScreenSizeHandler.smaller * 0.018).clamp(10.0, 14.0);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed("/donate"),
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/donate.png',
                width: iconSize,
                height: iconSize,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
              SizedBox(height: fontSize * 0.2),
              Text(
                "Donate",
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leadingWidth = showBackButton
        ? (ScreenSizeHandler.smaller * 0.28).clamp(100.0, 130.0)
        : (ScreenSizeHandler.smaller * 0.2).clamp(60.0, 90.0);
    final iconBtnSize = (ScreenSizeHandler.smaller * 0.065).clamp(36.0, 48.0);
    final titleSize = (ScreenSizeHandler.smaller * 0.058).clamp(18.0, 26.0);
    final actionIconSize = (ScreenSizeHandler.smaller * 0.04).clamp(20.0, 28.0);
    final actionFontSize = (ScreenSizeHandler.smaller * 0.018).clamp(10.0, 14.0);

    return AppBar(
      leadingWidth: leadingWidth,
      leading: showBackButton
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios, size: iconBtnSize * 0.6),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: Size(iconBtnSize * 0.8, iconBtnSize * 0.8),
                  ),
                ),
                _buildDonationButton(context),
              ],
            )
          : _buildDonationButton(context),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: ScreenSizeHandler.smaller * 0.02),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.toNamed("/mytickets"),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ticket-2.png',
                      width: actionIconSize,
                      height: actionIconSize,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: actionFontSize * 0.2),
                    Text(
                      "My tickets",
                      style: TextStyle(color: Colors.white, fontSize: actionFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: ScreenSizeHandler.smaller * 0.02),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.toNamed("/cart"),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/cart_icon.png',
                      width: actionIconSize,
                      height: actionIconSize,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: actionFontSize * 0.2),
                    Text(
                      "Cart",
                      style: TextStyle(color: Colors.white, fontSize: actionFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
