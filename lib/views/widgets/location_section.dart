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
            'https://maps.app.goo.gl/nxQRzp27DftN3XqE7?g_st=com.google.maps.preview.copy'); // Replace with the desired coordinates
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
                    "Balloon Theatre",
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
                    "Cornich El Nile, Agouza, Giza Governate",
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