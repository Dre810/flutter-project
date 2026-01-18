import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create user object from Firebase User
  AppUser? _userFromFirebase(User? user, Map<String, dynamic>? data) {
    if (user == null) return null;
    return AppUser.fromMap(data ?? {}, user.uid);
  }

  // Register with email & password
  Future<AppUser?> registerWithEmail(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;

      // Save user in Firestore
      await _db.collection('users').doc(user.uid).set({
        'email': email,
        'role': role,
      });

      return _userFromFirebase(user, {'email': email, 'role': role});
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // Sign in with email & password
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;

      // Fetch user data from Firestore
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      return _userFromFirebase(user, doc.data() as Map<String, dynamic>?);
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}