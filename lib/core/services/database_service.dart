import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid uuid = Uuid();

  Future<void> uploadSeatsToFirestore() async {
    try {
      var seatsData = {
        "section1": {
          "price": 200,
          "seat_names": _generateSeats("A", 15, true) // Odd seats
            ..addAll(_generateSeats("B", 16, true))
            ..addAll(_generateSeats("C", 18, true))
            ..addAll(_generateSeats("D", 18, true))
            ..addAll(_generateSeats("E", 20, true))
            ..addAll(_generateSeats("F", 20, true)),
        },
        "section2": {
          "price": 200,
          "seat_names": _generateSeats("A", 15, false) // Even seats
            ..addAll(_generateSeats("B", 16, false))
            ..addAll(_generateSeats("C", 17, false))
            ..addAll(_generateSeats("D", 18, false))
            ..addAll(_generateSeats("E", 19, false))
            ..addAll(_generateSeats("F", 20, false)),
        },
        "section3": {
          "price": 120,
          "seat_names": _generateSeats("G", 22, true)
            ..addAll(_generateSeats("H", 23, true))
            ..addAll(_generateSeats("I", 25, true))
            ..addAll(_generateSeats("J", 25, true))
            ..addAll(_generateSeats("K", 27, true))
            ..addAll(_generateSeats("L", 26, true)),
        },
        "section4": {
          "price": 120,
          "seat_names": _generateSeats("G", 22, false)
            ..addAll(_generateSeats("H", 23, false))
            ..addAll(_generateSeats("I", 24, false))
            ..addAll(_generateSeats("J", 25, false))
            ..addAll(_generateSeats("K", 27, false))
            ..addAll(_generateSeats("L", 26, false)),
        },
        "section5": {
          "price": 75,
          "seat_names": _generateSeats("M", 17, true)
            ..addAll(_generateSeats("N", 20, true))
            ..addAll(_generateSeats("O", 20, true))
            ..addAll(_generateSeats("P", 20, true))
            ..addAll(_generateSeats("Q", 22, true))
            ..addAll(_generateSeats("R", 22, true))
            ..addAll(_generateSeats("S", 25, true))
            ..addAll(_generateSeats("T", 21, true)),
        },
        "section6": {
          "price": 75,
          "seat_names": _generateSeats("M", 20, false)
            ..addAll(_generateSeats("N", 20, false))
            ..addAll(_generateSeats("O", 21, false))
            ..addAll(_generateSeats("P", 20, false))
            ..addAll(_generateSeats("Q", 22, false))
            ..addAll(_generateSeats("R", 23, false))
            ..addAll(_generateSeats("S", 26, false))
            ..addAll(_generateSeats("T", 20, false)),
        },
      };

      await _firestore.collection("seats").doc("seats").set(seatsData);

      print("✅ Seats uploaded successfully!");
    } catch (e) {
      print("❌ Error uploading seats: $e");
    }
  }

  // Generate seats with status "available" and user_id as null
  Map<String, dynamic> _generateSeats(String row, int count, bool isOdd) {
    Map<String, dynamic> seatMap = {};

    for (int i = 1; i <= count; i++) {
      int seatNumber = isOdd ? (i * 2 - 1) : (i * 2);
      String seatId = "$row$seatNumber";

      seatMap[seatId] = {
        "status": "available",
        "uuid": uuid.v4(),
        "user_id": null,
      };
    }

    return seatMap;
  }
}
