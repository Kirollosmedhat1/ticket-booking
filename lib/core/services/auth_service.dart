import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **🔹 Register a new user and send email verification**
  Future<User?> registerWithEmail(String email, String password, String fullName, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await sendEmailVerification(user);

        // Save user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'phone': phone,
          'email': email,
          'uid': user.uid,
          'emailVerified': user.emailVerified, 
          'phoneVerified': false, // Initially false
        });
      }
      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  /// **🔹 Login only if email is verified**
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.reload(); // Refresh user data
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!user.emailVerified) {
          throw Exception("Please verify your email before logging in.");
        }

        return user;
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
    return null;
  }

  /// **🔹 Send Email Verification**
  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  /// **🔹 Send Phone Number Verification (via OTP)**
  Future<void> verifyPhoneNumber(String phoneNumber, Function(String, int?) codeSentCallback) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser?.updatePhoneNumber(credential);
        await _firestore.collection('users').doc(_auth.currentUser?.uid).update({'phoneVerified': true});
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception("Phone verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSentCallback(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// **🔹 Confirm OTP Code for Phone Verification**
  Future<void> confirmOtpCode(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await _auth.currentUser?.updatePhoneNumber(credential);
      await _firestore.collection('users').doc(_auth.currentUser?.uid).update({'phoneVerified': true});
    } catch (e) {
      throw Exception("OTP verification failed: $e");
    }
  }

  /// **🔹 Logout User**
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// **🔹 Get Current User**
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
