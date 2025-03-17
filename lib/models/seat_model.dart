class Seat {
  final String id;
  final String seatNumber;
  String status;
  int price;

  Seat({
    required this.id,
    required this.seatNumber,
    required this.status,
    required this.price,
  });

  factory Seat.fromMap(Map<String, dynamic> data, String id) {
    return Seat(
      id: data['uuid'],
      seatNumber: id,
      status: data['status'] ?? 'unknown',
      price: data['price'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'seatNumber': seatNumber, 'status': status, 'price': price};
  }
}