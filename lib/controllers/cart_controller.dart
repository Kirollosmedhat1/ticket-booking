import 'package:darbelsalib/models/seat_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var selectedSeats = <String, Seat>{}.obs;
  var totalPrice = 0.obs;

  void addSeat(String seatNumber, Seat seat) {
    if (!selectedSeats.containsKey(seatNumber)) {
      selectedSeats[seatNumber] = seat;
      totalPrice.value += seat.price;
    }
  }

  void removeSeat(String seatNumber) {
    print("🔴 Removing seat: $seatNumber");

    selectedSeats.remove(seatNumber); // ✅ This will trigger UI updates
    totalPrice.value =
        selectedSeats.values.fold(0, (sum, seat) => sum + seat.price);

    print("🟢 Remaining seats: ${selectedSeats.keys.toList()}");
  }

  void clearCart() {
    selectedSeats.clear();
    totalPrice.value = 0;
  }
}
