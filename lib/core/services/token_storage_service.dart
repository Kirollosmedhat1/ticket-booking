import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _tokenKey = 'auth_token';

  // Save the token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('Token saved: $token'); // Debug print
  }

  // Get the token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print('Token retrieved: $token'); // Debug print
    return token;
  }

  // Clear the token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('Token cleared'); // Optional: Debug print
  }
}
