// ignore_for_file: avoid_types_as_parameter_names

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxMap<String, String> seatsData = <String, String>{}.obs; // Seat statuses
  RxList<String> selectedSeats = <String>[].obs; // User-selected seats
  RxMap<String, DateTime> reservationTimers = <String, DateTime>{}.obs; // Reservation timers
  RxMap<String, double> seatPrices = <String, double>{}.obs; // Stores seat prices
  RxMap<String, String> seatCategories = <String, String>{}.obs; // Stores seat categories

  @override
  void onInit() {
    super.onInit();
    _listenToSeatUpdates();
  }

  /// **🔹 Listen for real-time seat status updates from Firestore**
  void _listenToSeatUpdates() {
    _firestore.collection('seats').snapshots().listen((snapshot) {
      Map<String, String> updatedSeats = {};
      Map<String, double> updatedPrices = {};
      Map<String, String> updatedCategories = {};

      for (var doc in snapshot.docs) {
        updatedSeats[doc.id] = doc['status'].toString();
        updatedPrices[doc.id] = (doc['price'] as num).toDouble();
        updatedCategories[doc.id] = doc['category'] ?? "Unknown";
      }

      seatsData.assignAll(updatedSeats);
      seatPrices.assignAll(updatedPrices);
      seatCategories.assignAll(updatedCategories);
    });
  }

  /// **🔹 Get Seat Price**
  double getSeatPrice(String seatNumber) {
    return seatPrices[seatNumber] ?? 0.0;
  }

  /// **🔹 Get Seat Category**
  String getSeatCategory(String seatNumber) {
    return seatCategories[seatNumber] ?? "Unknown";
  }

  /// **🔹 Get Total Price for Checkout**
  double getTotalPrice() {
    return selectedSeats.fold(0.0, (sum, seat) => sum + getSeatPrice(seat));
  }

  /// **🔹 Handle Seat Selection**
  void selectSeat(String seatNumber) async {
    String currentStatus = seatsData[seatNumber] ?? "available";

    if (currentStatus == "booked") {
      Get.snackbar("Seat Unavailable", "This seat is already booked.");
      return;
    }

    if (selectedSeats.contains(seatNumber)) {
      removeSeat(seatNumber);
    } else if (selectedSeats.length < 10) {
      await _reserveSeat(seatNumber);
    } else {
      Get.snackbar("Limit Reached", "You can select up to 10 seats.");
    }
  }

  /// **🔹 Reserve a Seat and Store `reservedUntil` in Firestore**
  Future<void> _reserveSeat(String seatNumber) async {
    DateTime expiryTime = DateTime.now().add(Duration(minutes: 10));
    selectedSeats.add(seatNumber);
    reservationTimers[seatNumber] = expiryTime;

    await _firestore.collection('seats').doc(seatNumber).update({
      'status': 'reserved',
      'reservedUntil': expiryTime.toIso8601String(),
    });

    // Start countdown to expire reservation
    Future.delayed(Duration(minutes: 10), () {
      _expireReservation(seatNumber);
    });
  }

  /// **🔹 Remove a Seat from Cart and Reset in Firestore**
  Future<void> removeSeat(String seatNumber) async {
    selectedSeats.remove(seatNumber);
    reservationTimers.remove(seatNumber);

    await _firestore.collection('seats').doc(seatNumber).update({
      'status': 'available',
      'reservedUntil': null,
    });
  }

  /// **🔹 Expire Seat Reservation if Time Runs Out**
  Future<void> _expireReservation(String seatNumber) async {
    DateTime now = DateTime.now();
    DateTime? reservedUntil = reservationTimers[seatNumber];

    if (reservedUntil != null && now.isAfter(reservedUntil)) {
      selectedSeats.remove(seatNumber);
      reservationTimers.remove(seatNumber);

      await _firestore.collection('seats').doc(seatNumber).update({
        'status': 'available',
        'reservedUntil': null,
      });
    }
  }
}
