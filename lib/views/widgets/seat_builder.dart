import 'package:darbelsalib/views/widgets/custom_seat.dart';
import 'package:flutter/widgets.dart';

class SeatBuilder extends StatelessWidget {
  const SeatBuilder({
    super.key,
    required this.sectionNumber,
    required this.seatStatus,
    required this.onSeatSelected,
  });

  final int sectionNumber;
  final Map<String, String> seatStatus;
  final Function(String) onSeatSelected;

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
                          seat !=
                                  (row <= 1
                                      ? 8
                                      : row == 2 || row == 3
                                          ? 9
                                          : 10)
                              ? seatStatus[
                                      "${String.fromCharCode(65 + row)}${(seat < (row < 2 ? 8 : row < 4 ? 9 : 10) ? seat + 1 : seat) * 2}"] ??
                                  "available"
                              : "empty",
                          onSeatSelected,
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
                          seat !=
                                  (row == 0 || row == 1
                                      ? 8
                                      : row == 2 || row == 3
                                          ? 9
                                          : 10)
                              ? seatStatus[
                                      "${String.fromCharCode(65 + row)}${(seat < (row < 2 ? 8 : row < 4 ? 9 : 10) ? seat + 1 : seat) * 2 - 1}"] ??
                                  "available"
                              : "empty",
                          onSeatSelected,
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
                          seat !=
                                  (row == 0 || row == 1
                                      ? 11
                                      : row == 2
                                          ? 12
                                          : row == 3
                                              ? 12
                                              : 13)
                              ? seatStatus[
                                      "${String.fromCharCode(71 + row)}${(seat < (row == 0 || row == 1 ? 11 : row == 2 ? 12 : row == 3 ? 12 : 13) ? seat + 1 : seat) * 2}"] ??
                                  "available"
                              : "empty",
                          onSeatSelected,
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
                          seat !=
                                  (row == 0 || row == 1
                                      ? 11
                                      : row == 2 || row == 3
                                          ? 12
                                          : 13)
                              ? seatStatus[
                                      "${String.fromCharCode(71 + row)}${(seat < (row == 0 || row == 1 ? 11 : row == 2 || row == 3 ? 12 : 13) ? seat + 1 : seat) * 2 - 1}"] ??
                                  "available"
                              : "empty",
                          onSeatSelected,
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
                        seat !=
                                (row == 0 || row == 1 || row == 3
                                    ? 10
                                    : row == 2 || row == 4 || row == 5
                                        ? 11
                                        : row == 6
                                            ? 12
                                            : 11)
                            ? seatStatus[
                                    "${String.fromCharCode(77 + row)}${(seat < (row == 0 || row == 1 || row == 3 ? 10 : row == 2 || row == 4 || row == 5 ? 11 : row == 6 ? 12 : 11) ? seat + 1 : seat) * 2}"] ??
                                "available"
                            : "empty",
                        onSeatSelected,
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
                          seat !=
                                  (row == 0
                                      ? 8
                                      : row == 1 || row == 2 || row == 3
                                          ? 10
                                          : row == 4 || row == 5 || row == 7
                                              ? 11
                                              : 12)
                              ? seatStatus[
                                      "${String.fromCharCode(77 + row)}${(seat < (row == 0 ? 8 : row == 1 || row == 2 || row == 3 ? 10 : row == 4 || row == 5 || row == 7 ? 11 : 12) ? seat + 1 : seat) * 2 - 1}"] ??
                                  "available"
                              : "empty",
                          onSeatSelected,
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// **Build Individual Seat Widget**
Widget _buildSeat(
    String seatNumber, String status, Function(String) onSeatSelected) {
  // String status = ticketController.seatsData[seatNumber] ?? "available";

  return CustomSeat(
    seatNumber: seatNumber,
    status: status,
    onSeatSelected: onSeatSelected,
  );
}
