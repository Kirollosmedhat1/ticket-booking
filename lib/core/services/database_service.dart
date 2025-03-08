import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateSeatStatus(String seatNumber, String status) async {
    try {
      await _firestore.collection('seats').doc(seatNumber).update({'status': status});
    } catch (e) {
      print("Error updating seat status: $e");
    }
  }
}
