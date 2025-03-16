import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid uuid = Uuid();

  

     
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
