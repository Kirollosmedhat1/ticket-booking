import 'package:darbelsalib/views/widgets/contact_us_entry.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ContactUsEntry(
          text: "0120-6539-430",
          isUnderLined: false,
          isNormal: false,
          customIcon: FontAwesomeIcons.whatsapp,
          iconColor: Colors.green,
        ),
        GestureDetector(
          onTap: () async {
            final url = Uri.parse(
                'https://www.instagram.com/darbsalib.agouza/');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ContactUsEntry(
              text: "Darbsalib.agouza",
              isUnderLined: true,
              isNormal: false,
              customIcon: FontAwesomeIcons.instagram,
              iconColor: Color(0xFFcf1b77),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final url = Uri.parse(
                'https://www.facebook.com/share/1F9SZTvA55/?mibextid=wwXIfr');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ContactUsEntry(
                text: "Darb Salib Agouza",
                isUnderLined: true,
                isNormal: false,
                customIcon: FontAwesomeIcons.facebookF,
                iconColor: Color(0xFF0080ff)),
          ),
        )
      ],
    );
  }
}
