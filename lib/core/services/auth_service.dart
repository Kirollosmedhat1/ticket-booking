import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register and send verification email
  Future<User?> registerWithEmail(String email, String password, String fullName, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = userCredential.user;

      if (user != null) {
        await sendEmailVerification(user);

        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'phone': phone,
          'email': email,
          'uid': user.uid,
          'emailVerified': user.emailVerified, 
        });
      }
      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Login only if email is verified
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.reload(); // Refresh user data
        if (!user.emailVerified) {
          throw Exception("Please verify your email before logging in.");
        }
      }
      return user;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // Reset password using Firebase
Future<void> confirmResetPassword(String oobCode, String newPassword) async {
  try {
    await FirebaseAuth.instance.confirmPasswordReset(
      code: oobCode,
      newPassword: newPassword,
    );
  } catch (e) {
    throw Exception("Password reset failed: $e");
  }
}


  // Resend verification email
  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  // Logout user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the currently logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
