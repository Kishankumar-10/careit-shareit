import '../../../core/services/firestore_service.dart';
import '../../location/models/user_profile.dart';

class ProfileRepository {
  final FirestoreService _firestoreService =
      FirestoreService.instance;

  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestoreService.saveUserProfile(profile);
  }

  Future<UserProfile?> getUserProfile() async {
    return await _firestoreService.getUserProfile();
  }
}