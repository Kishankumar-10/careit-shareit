import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/location/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  /// Save User Profile
  Future<void> saveUserProfile(UserProfile profile) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await usersCollection.doc(uid).set(profile.toMap());
  }

  /// Get User Profile
  Future<UserProfile?> getUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final document = await usersCollection.doc(uid).get();

    if (!document.exists) {
      return null;
    }

    return UserProfile.fromMap(document.data()!);
  }
}
