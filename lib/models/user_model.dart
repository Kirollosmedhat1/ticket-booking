class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String token; // Add token property

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.token, // Add token to the constructor
  });
}