import 'package:darbelsalib/screen_size_handler.dart';
import 'package:darbelsalib/views/widgets/custom_seat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SelectSeat extends StatefulWidget {
  @override
  State<SelectSeat> createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  late final String section;

  @override
  void initState() {
    super.initState();
    section = Get.parameters['sectionNumber']!;
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
              child: SeatBuilder(sectionNumber: int.parse(section)),
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
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text(
                        "210 EGP",
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
                    },
                  ),
                ],
              ),
            )
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

/// **Build Individual Seat Widget**
Widget _buildSeat(String seatNumber, String status) {
  // String status = ticketController.seatsData[seatNumber] ?? "available";

  return CustomSeat(
    seatNumber: seatNumber,
    status: status,
    onSeatSelected: (String seat) {},
  );
}

class SeatBuilder extends StatelessWidget {
  const SeatBuilder({super.key, required this.sectionNumber});

  final int sectionNumber;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController(
      initialScrollOffset:
          MediaQuery.of(context).size.width / (sectionNumber <= 2 ? 2 : 1.03),
    );
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionNumber == 1)
            for (int row = 0; row < 6; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: row == 5
                        ? 0
                        : row == 4 || row == 3
                            ? 40
                            : row == 2 || row == 1
                                ? 80
                                : 120,
                  ),
                  child: Row(
                    children: [
                      for (int seat = 0; seat <= (row + 15); seat++)
                        _buildSeat(
                          seat ==
                                  (row <= 1
                                      ? 8
                                      : row == 2 || row == 3
                                          ? 9
                                          : 10)
                              ? ""
                              : "${String.fromCharCode(65 + row)}${(seat < (row < 2 ? 8 : row < 4 ? 9 : 10) ? seat + 1 : seat) * 2}",
                          seat ==
                                  (row <= 1
                                      ? 8
                                      : row == 2 || row == 3
                                          ? 9
                                          : 10)
                              ? "empty"
                              : "available",
                        ),
                    ].reversed.toList(), // Reverse the order of the seats
                  ),
                ),
              ),
          if (sectionNumber == 2)
            for (int row = 0; row < 6; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: row == 5 || row == 4
                        ? 0
                        : row == 2 || row == 3
                            ? 40
                            : 80,
                  ),
                  child: Row(
                    children: [
                      for (int seat = 0;
                          seat <=
                              (row == 0 || row == 1
                                  ? row + 15
                                  : row == 2 || row == 3
                                      ? 18
                                      : 20);
                          seat++)
                        _buildSeat(
                          seat ==
                                  (row == 0 || row == 1
                                      ? 8
                                      : row == 2 || row == 3
                                          ? 9
                                          : 10)
                              ? ""
                              : "${String.fromCharCode(65 + row)}${(seat < (row < 2 ? 8 : row < 4 ? 9 : 10) ? seat + 1 : seat) * 2 - 1}",
                          seat ==
                                  (row == 0 || row == 1
                                      ? 8
                                      : row == 2 || row == 3
                                          ? 9
                                          : 10)
                              ? "empty"
                              : "available",
                        ),
                    ], // Do not reverse the order of the seats
                  ),
                ),
              ),
          if (sectionNumber == 3)
            for (int row = 0; row < 6; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: row == 5
                        ? 0
                        : row == 4
                            ? 40
                            : row == 3
                                ? 80
                                : row == 2 || row == 1
                                    ? 120
                                    : 160,
                  ),
                  child: Row(
                    children: [
                      for (int seat = 0;
                          seat <=
                              (row < 4
                                  ? row + 22
                                  : row == 4
                                      ? 27
                                      : 28);
                          seat++)
                        _buildSeat(
                          seat ==
                                  (row == 0 || row == 1
                                      ? 11
                                      : row == 2
                                          ? 12
                                          : row == 3
                                              ? 12
                                              : 13)
                              ? ""
                              : "${String.fromCharCode(71 + row)}${(seat < (row == 0 || row == 1 ? 11 : row == 2 ? 12 : row == 3 ? 12 : 13) ? seat + 1 : seat) * 2}",
                          seat ==
                                  (row == 0 || row == 1
                                      ? 11
                                      : row == 2
                                          ? 12
                                          : row == 3
                                              ? 12
                                              : 13)
                              ? "empty"
                              : "available",
                        ),
                    ]
                        .reversed
                        .toList(), // Do not reverse the order of the seats
                  ),
                ),
              ),
          if (sectionNumber == 4)
            for (int row = 0; row < 6; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: row == 5 || row == 4
                          ? 0
                          : row == 3 || row == 2
                              ? 40
                              : 80),
                  child: Row(
                    children: [
                      for (int seat = 0;
                          seat <=
                              (row <= 1
                                  ? row + 22
                                  : row == 2 || row == 3
                                      ? 25
                                      : row == 4
                                          ? 27
                                          : 28);
                          seat++)
                        _buildSeat(
                          seat ==
                                  (row == 0 || row == 1
                                      ? 11
                                      : row == 2 || row == 3
                                          ? 12
                                          : 13)
                              ? ""
                              : "${String.fromCharCode(71 + row)}${(seat < (row == 0 || row == 1 ? 11 : row == 2 || row == 3 ? 12 : 13) ? seat + 1 : seat) * 2 - 1}",
                          seat ==
                                  (row == 0 || row == 1
                                      ? 11
                                      : row == 2 || row == 3
                                          ? 12
                                          : 13)
                              ? "empty"
                              : "available",
                        ),
                    ],
                  ),
                ),
              ),
          if (sectionNumber == 5)
            for (int row = 0; row < 8; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: row == 7
                          ? 200
                          : row == 6
                              ? 0
                              : row == 5
                                  ? 80
                                  : row == 4
                                      ? 120
                                      : 160),
                  child: Row(
                      children: [
                    for (int seat = 0;
                        seat <=
                            (row <= 1 || row == 3
                                ? 20
                                : row == 2
                                    ? 21
                                    : row == 4
                                        ? 22
                                        : row == 5
                                            ? 23
                                            : row == 6
                                                ? 26
                                                : 20);
                        seat++)
                      _buildSeat(
                        seat ==
                                (row == 0 || row == 1 || row == 3
                                    ? 10
                                    : row == 2 || row == 4 || row == 5
                                        ? 11
                                        : row == 6
                                            ? 12
                                            : 11)
                            ? ""
                            : "${String.fromCharCode(77 + row)}${(seat < (row == 0 || row == 1 || row == 3 ? 10 : row == 2 || row == 4 || row == 5 ? 11 : row == 6 ? 12 : 11) ? seat + 1 : seat) * 2}",
                        seat ==
                                (row == 0 || row == 1 || row == 3
                                    ? 10
                                    : row == 2 || row == 4 || row == 5
                                        ? 11
                                        : row == 6
                                            ? 12
                                            : 11)
                            ? "empty"
                            : "available",
                      ),
                  ].reversed.toList()),
                ),
              ),
          if (sectionNumber == 6)
            for (int row = 0; row < 8; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                    padding: EdgeInsets.only(
                        left: row == 7 || row == 5 || row == 4
                            ? 40
                            : row == 6
                                ? 0
                                : row == 1 || row == 2 || row == 3
                                    ? 80
                                    : 160),
                    child: Row(
                      children: [
                        for (int seat = 0;
                            seat <=
                                (row == 0
                                    ? 17
                                    : row <= 3
                                        ? 20
                                        : row == 4 || row == 5
                                            ? 22
                                            : row == 5
                                                ? 23
                                                : row == 6
                                                    ? 25
                                                    : 21);
                            seat++)
                          _buildSeat(
                            seat ==
                                    (row == 0
                                        ? 8
                                        : row == 1 || row == 2 || row == 3
                                            ? 10
                                            : row == 4 || row == 5 || row == 7
                                                ? 11
                                                : 12)
                                ? ""
                                : "${String.fromCharCode(77 + row)}${(seat < (row == 0 ? 8 : row == 1 || row == 2 || row == 3 ? 10 : row == 4 || row == 5 || row == 7 ? 11 : 12) ? seat + 1 : seat) * 2 - 1}",
                            seat ==
                                    (row == 0
                                        ? 8
                                        : row == 1 || row == 2 || row == 3
                                            ? 10
                                            : row == 4 || row == 5 || row == 7
                                                ? 11
                                                : 12)
                                ? "empty"
                                : "available",
                          ),
                      ],
                    )),
              ),
        ],
      ),
    );
  }
}
