import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxMap<String, String> seatsData = <String, String>{}.obs; // Seat statuses
  RxList<String> selectedSeats = <String>[].obs; // User-selected seats
  RxMap<String, DateTime> reservationTimers = <String, DateTime>{}.obs; // Reservation timers

  @override
  void onInit() {
    super.onInit();
    _listenToSeatUpdates(); // Listen for real-time updates
  }

  /// **Real-time listener for seat status updates**
  void _listenToSeatUpdates() {
    _firestore.collection('seats').snapshots().listen((snapshot) {
      Map<String, String> updatedSeats = {};
      for (var doc in snapshot.docs) {
        updatedSeats[doc.id] = doc['status'].toString();
      }
      seatsData.assignAll(updatedSeats);
    });
  }

  /// **Handle Seat Selection**
  void selectSeat(String seatNumber) {
    String currentStatus = seatsData[seatNumber] ?? "available";

    if (currentStatus == "booked") {
      Get.snackbar("Seat Unavailable", "This seat is already booked.");
      return;
    }

    if (selectedSeats.contains(seatNumber)) {
      removeSeat(seatNumber);
    } else if (selectedSeats.length < 10) {
      _reserveSeat(seatNumber);
    } else {
      Get.snackbar("Limit Reached", "You can select up to 10 seats.");
    }
  }

  /// **Reserve a seat**
  void _reserveSeat(String seatNumber) {
    seatsData[seatNumber] = "reserved";
    selectedSeats.add(seatNumber);
    reservationTimers[seatNumber] = DateTime.now().add(Duration(minutes: 10));

    // Update Firestore
    _firestore.collection('seats').doc(seatNumber).update({'status': 'reserved'});

    // Start timer to release seat after 10 minutes
    Future.delayed(Duration(minutes: 10), () {
      if (selectedSeats.contains(seatNumber)) {
        _expireReservation(seatNumber);
      }
    });
  }

  /// **Remove a seat from selection**
  void removeSeat(String seatNumber) {
    selectedSeats.remove(seatNumber);
    seatsData[seatNumber] = "available";
    reservationTimers.remove(seatNumber);

    // Update Firestore
    _firestore.collection('seats').doc(seatNumber).update({'status': 'available'});
  }

  /// **Expire reservation if not purchased within 10 minutes**
  void _expireReservation(String seatNumber) {
    if (selectedSeats.contains(seatNumber)) {
      selectedSeats.remove(seatNumber);
      seatsData[seatNumber] = "available";
      reservationTimers.remove(seatNumber);

      // Update Firestore
      _firestore.collection('seats').doc(seatNumber).update({'status': 'available'});
    }
  }
}
