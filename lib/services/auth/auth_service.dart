import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of FirebaseAuth & Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Sign in user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Update Users collection without overwriting existing data
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true)); // ✅ Keeps old data safe

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up (Store new users separately)
  Future<UserCredential> signupWithEmailAndPassword(
      String email, String password, String name, String contact, String avatarUrl) async {
    try {
      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Save full user details in 'NewUsers' collection (for original registration data)
      await _firestore.collection('NewUsers').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'contact': contact,
        'avatar': avatarUrl, // Store avatar
        'createdAt': FieldValue.serverTimestamp(), // Timestamp
      });

      // Save minimal data in 'Users' collection (for active user session)
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Fetch registration data of current user
  Future<Map<String, dynamic>?> getRegistrationData() async {
    try {
      User? user = getCurrentUser();
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore.collection('NewUsers').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching registration data: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
