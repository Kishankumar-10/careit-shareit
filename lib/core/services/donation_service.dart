import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/location/models/donation_model.dart';
import '../../features/auth/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDonation(DonationModel donation) async {
    await _firestore.collection('donations').add(donation.toMap());
  }

  Stream<List<DonationModel>> getDonations() {
    return _firestore
        .collection('donations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return DonationModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Stream<List<DonationModel>> getMyDonations() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('donations')
        .where('donorId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return DonationModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> acceptDonation(String donationId) async {
    final profileRepository = ProfileRepository();
    final receiver = await profileRepository.getUserProfile();

    await _firestore.collection('donations').doc(donationId).update({
      'status': 'accepted',

      'acceptedByName': receiver?.name ?? '',
      'acceptedByPhone': receiver?.phoneNumber ?? '',

      'acceptedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeDonation(String donationId) async {
    await _firestore.collection('donations').doc(donationId).update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
  }
}
