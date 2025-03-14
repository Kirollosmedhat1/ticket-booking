import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid uuid = Uuid();

  Future<void> uploadSeatsToFirestore() async {
    DocumentReference seatsDoc = _firestore.collection('seats').doc('seats');

    Map<String, dynamic> formattedData = {
      'first_section': _generateSeats("first_section", 200, {
        'A': 15, 'B': 16, 'C': 18, 'D': 18, 'E': 20, 'F': 20
      }, isOdd: true),
      'second_section': _generateSeats("second_section", 200, {
        'A': 15, 'B': 16, 'C': 17, 'D': 18, 'E': 19, 'F': 20
      }, isOdd: false),
      'third_section': _generateSeats("third_section", 120, {
        'G': 22, 'H': 23, 'I': 25, 'J': 25, 'K': 27, 'L': 26
      }, isOdd: true),
      'fourth_section': _generateSeats("fourth_section", 120, {
        'G': 22, 'H': 23, 'I': 24, 'J': 25, 'K': 27, 'L': 26
      }, isOdd: false),
      'fifth_section': _generateSeats("fifth_section", 75, {
        'M': 17, 'N': 20, 'O': 20, 'P': 20, 'Q': 22, 'R': 22, 'S': 25, 'T': 21
      }, isOdd: true),
      'sixth_section': _generateSeats("sixth_section", 75, {
        'M': 20, 'N': 20, 'O': 21, 'P': 20, 'Q': 22, 'R': 23, 'S': 26, 'T': 20
      }, isOdd: false),
    };

    await seatsDoc.set(formattedData);
    print("✅ Seats uploaded successfully!");
  }

  Map<String, dynamic> _generateSeats(
      String section, int price, Map<String, int> lines, {required bool isOdd}) {
    Map<String, dynamic> sectionData = {
      'price': price,
      'seat_names': {},
    };

    lines.forEach((line, count) {
      List<int> seats = List.generate(count, (index) {
        return isOdd ? (index * 2 + 1) : ((index + 1) * 2);
      });

      for (int seatNum in seats) {
        String seatId = "$line$seatNum";
        sectionData['seat_names'][seatId] = {
          'status': 'available',
          'uuid': uuid.v4(),
          'user_id': null, // Set user_id as null for now
        };
      }
    });

    return sectionData;
  }
}
