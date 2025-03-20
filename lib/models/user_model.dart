class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String email; // Add email field
  final String token;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email, // Add email field
    required this.token,
  });
}