import 'package:darbelsalib/screen_size_handler.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(
            'https://maps.app.goo.gl/e7GuKjFKZL4T4zE77?g_st=ic'); // Replace with the desired coordinates
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: ScreenSizeHandler.smaller * 0.07,
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenSizeHandler.smaller * 0.018),
                  child: Text(
                    "Qasr El Nile Theatre",
                    style: TextStyle(
                        fontSize: ScreenSizeHandler.smaller * 0.037,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: ScreenSizeHandler.smaller * 0.07,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenSizeHandler.smaller * 0.018),
                  child: Text(
                    "Qasr El Nile St., West El Balad,\nCairo Governate (Tap for Location)",
                    style: TextStyle(
                        fontSize: ScreenSizeHandler.smaller * 0.032,
                        color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}