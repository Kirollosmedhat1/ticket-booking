class Ticket {
  final String id;
  final String userId;
  final String ticketType;
  final double price;
  final bool isBooked;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.userId,
    required this.ticketType,
    required this.price,
    required this.isBooked,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['user_id'],
      ticketType: json['ticket_type'],
      price: (json['price'] as num).toDouble(),
      isBooked: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}