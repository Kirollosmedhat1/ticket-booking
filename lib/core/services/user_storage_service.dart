import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const String _fullNameKey = 'user_full_name';
  static const String _phoneNumberKey = 'user_phone_number';
  static const String _emailKey = 'user_email'; // Add email key
  static const String _firstNameKey = 'user_first_name'; // Add first name key
  static const String _lastNameKey = 'user_last_name'; // Add last name key

  // Save the user's full name
  Future<void> saveFullName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
  }

  // Get the user's full name
  Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  // Save the user's phone number
  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, phoneNumber);
  }

  // Get the user's phone number
  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  // Save the user's email
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  // Get the user's email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Save the user's first name
  Future<void> saveFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstNameKey, firstName);
  }

  // Get the user's first name
  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstNameKey);
  }

  // Save the user's last name
  Future<void> saveLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNameKey, lastName);
  }

  // Get the user's last name
  Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastNameKey);
  }

  // Clear all user details
  Future<void> clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fullNameKey);
    await prefs.remove(_phoneNumberKey);
    await prefs.remove(_emailKey); // Clear email
    await prefs.remove(_firstNameKey); // Clear first name
    await prefs.remove(_lastNameKey); // Clear last name
  }
}