class TicketModel {
  final String id;
  final String seatNumber;
  final String section;
  final String buyerName;
  final String buyerPhoneNumber;
  final DateTime createdAt;

  TicketModel({
    required this.id,
    required this.seatNumber,
    required this.section,
    required this.buyerName,
    required this.buyerPhoneNumber,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      seatNumber: json['seat']['seat_number'],
      section: _capitalize(json['seat']['category']['name']),
      buyerName: "${json['user']['first_name']} ${json['user']['last_name']}",
      buyerPhoneNumber: json['user']['phone_number'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() +
        input
            .substring(1)
            .replaceAllMapped(RegExp(r'(\d+)'), (Match m) => ' ${m[0]}');
  }
}
