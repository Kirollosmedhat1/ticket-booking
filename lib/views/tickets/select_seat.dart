import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_seat.dart';
import 'package:darbelsalib/views/widgets/seat_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isLoggedIn() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null;
}

class SelectSeat extends StatefulWidget {
  @override
  State<SelectSeat> createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  late final String section;
  final Map<String, String> seatStatus = {};
  int totalPrice = 0;
  int selectedSeatsCount = 0;

  @override
  void initState() {
    super.initState();
    section = Get.parameters['sectionNumber']!;
  }

  void _onSeatSelected(String seatNumber) {
    setState(() {
      if (seatStatus[seatNumber] == "selected") {
        seatStatus[seatNumber] = "available";
        totalPrice -= 80;
        selectedSeatsCount--;
      } else if (selectedSeatsCount < 5) {
        seatStatus[seatNumber] = "selected";
        totalPrice += 80;
        selectedSeatsCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          'Select Seat',
          style: TextStyle(
              fontSize: ScreenSizeHandler.smaller * 0.065,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/screen.png",
            ),
            // put seats here
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SeatBuilder(
                sectionNumber: int.parse(section),
                seatStatus: seatStatus,
                onSeatSelected: _onSeatSelected,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                SeatIndicator(
                  color: Color(0xff1c1c1c),
                  description: "Available",
                ),
                SeatIndicator(
                  description: "Reserved",
                  color: Color(0xffdfa000),
                ),
                SeatIndicator(
                  description: "Selected",
                  color: Color(0xff7cc3f6),
                ),
              ],
            ),
            const Spacer(),
            if (selectedSeatsCount > 0) ...[
              Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        Text(
                          "$totalPrice EGP",
                          style: TextStyle(
                              color: Color(0xffdfa000),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    CustomButton(
                      text: "Book",
                      width: 191,
                      height: 56,
                      color: Color(0xffdfa000),
                      onPressed: () {
                        // Add your onPressed logic here
                        if (!isLoggedIn()) {
                          Get.toNamed("/register");
                        } else {
                          Get.toNamed("/payment");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SeatIndicator extends StatelessWidget {
  const SeatIndicator(
      {super.key, required this.description, required this.color});

  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              //rounded corners
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
