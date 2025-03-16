import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/seat_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    listenToSeatsUpdates(section); // Call the function here
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                "Limit Exceeded",
                style: TextStyle(
                    color: Color(0xffdfa000),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                "You can only purchase 5 seats at a time.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  List<String> getNeighboringSections(int sectionNumber) {
    switch (sectionNumber) {
      case 1:
        return ['Stage', 'Section 3', '', 'Section 2'];
      case 2:
        return ['Stage', 'Section 4', 'Section 1', ''];
      case 3:
        return ['Section 1', 'Section 5', '', 'Section 4'];
      case 4:
        return ['Section 2', 'Section 6', 'Section 3', ''];
      case 5:
        return ['Section 3', '', '' 'Section 6'];
      case 6:
        return ['Section 4', '', 'Section 5', ''];
      default:
        return [];
    }
  }

  void listenToSeatsUpdates(String sectionName) {
    if (sectionName == '1') {
      sectionName = '2';
    } else if (sectionName == '2') {
      sectionName = '1';
    } else if (sectionName == '3') {
      sectionName = '4';
    } else if (sectionName == '4') {
      sectionName = '3';
    } else if (sectionName == '5') {
      sectionName = '6';
    } else if (sectionName == '6') {
      sectionName = '5';
    }

    FirebaseFirestore.instance
        .collection('seats')
        .doc('seats')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        print('No seat data found');
        return;
      }

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('section$sectionName')) {
        print('Section $sectionName not found');
        return;
      }

      Map<String, dynamic>? sectionData =
          data['section$sectionName'] as Map<String, dynamic>?;
      if (sectionData == null || !sectionData.containsKey('seat_names')) {
        print('No valid seat data in section $sectionName');
        return;
      }

      Map<String, dynamic>? seatNames =
          sectionData['seat_names'] as Map<String, dynamic>?;
      if (seatNames == null) {
        print('No seat names found in section $sectionName');
        return;
      }

      seatNames.forEach((seatNameKey, seatDetails) {
        if (seatDetails is Map<String, dynamic>) {
          String status = seatDetails['status'] ?? 'unknown';
          String userId = seatDetails['user_id']?.toString() ?? 'none';
          String uuid = seatDetails['uuid'] ?? 'none';

          print(
              'Section: $sectionName, Seat: $seatNameKey, Status: $status, User ID: $userId, UUID: $uuid');
          setState(() {
            seatStatus[seatNameKey] = status;
          });
          print(seatStatus);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int sectionNumber = int.parse(section);
    List<String> neighboringSections = getNeighboringSections(sectionNumber);

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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (sectionNumber == 1 || sectionNumber == 2)
                      Image.asset(
                        "assets/images/screen.png",
                      ),
                    Column(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          getNeighboringSections(sectionNumber)[0],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "You are currently in section $sectionNumber",
                      style: TextStyle(
                          color: Color(0xffdfa000),
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SeatBuilder(
                        sectionNumber: sectionNumber,
                        seatStatus: seatStatus,
                        onSeatSelected: _onSeatSelected,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                          SeatIndicator(
                            description: "On Hold",
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
