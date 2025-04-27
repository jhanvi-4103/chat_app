import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get currentUserId => _auth.currentUser!.uid;

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final doc = await _firestore.collection('Profile').doc(currentUserId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> updateUserBio(String newBio) async {
    await _firestore.collection('Profile').doc(currentUserId).update({
      'bio': newBio,
    });
  }

  Future<void> updateUserAvatar(String newAvatar) async {
    await _firestore.collection('Profile').doc(currentUserId).update({
      'avatar': newAvatar,
    });
  }
}