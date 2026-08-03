import 'package:flutter/material.dart';

import '../core/services/donation_service.dart';
import '../features/auth/repository/profile_repository.dart';
import '../features/location/models/user_profile.dart';
import '../features/location/models/donation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home_screen.dart';

import '../screens/auth/mobile_number_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final ProfileRepository _profileRepository = ProfileRepository();
  final DonationService _donationService = DonationService();

  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileRepository.getUserProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _nameController.text = profile?.name ?? "";
        _stateController.text = profile?.state ?? "";
        _cityController.text = profile?.city ?? "";
        _areaController.text = profile?.area ?? "";
        _pinCodeController.text = profile?.pinCode ?? "";
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint("Error loading profile: $e");
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MobileNumberScreen()),
      (route) => false,
    );
  }

  Future<void> _updateProfile() async {
    if (_profile == null) return;

    try {
      final updatedProfile = UserProfile(
        name: _nameController.text.trim(),
        phoneNumber: _profile!.phoneNumber,
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        pinCode: _pinCodeController.text.trim(),
      );

      await _profileRepository.saveUserProfile(updatedProfile);

      if (!mounted) return;

      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
    }
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableInfoRow({
    required IconData icon,
    required String title,
    required TextEditingController controller,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: title,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen(initialIndex: 0)),
        );
      },

      child: Scaffold(
        appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, size: 55, color: Colors.white),
              ),

              const SizedBox(height: 20),

              _isEditing
                  ? TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  )
                  : Text(
                    _profile?.name ?? "User",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

              const SizedBox(height: 8),

              Text(
                _profile?.phoneNumber ?? "",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_isEditing) {
                      await _updateProfile();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  icon: Icon(_isEditing ? Icons.save : Icons.edit),
                  label: Text(_isEditing ? "Save Changes" : "Edit Profile"),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "Location Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _isEditing
                          ? _buildEditableInfoRow(
                            icon: Icons.home_outlined,

                            title: "Address",
                            controller: _areaController,
                          )
                          : _buildInfoRow(
                            Icons.home_outlined,
                            "Address",
                            _profile?.area ?? "Not Available",
                          ),

                      const SizedBox(height: 12),

                      _isEditing
                          ? _buildEditableInfoRow(
                            icon: Icons.location_city,
                            title: "City",
                            controller: _cityController,
                          )
                          : _buildInfoRow(
                            Icons.location_city,
                            "City",
                            _profile?.city ?? "Not Available",
                          ),

                      const SizedBox(height: 12),

                      _isEditing
                          ? _buildEditableInfoRow(
                            icon: Icons.map,
                            title: "State",
                            controller: _stateController,
                          )
                          : _buildInfoRow(
                            Icons.map,
                            "State",
                            _profile?.state ?? "Not Available",
                          ),

                      const SizedBox(height: 12),

                      _isEditing
                          ? _buildEditableInfoRow(
                            icon: Icons.pin_drop,
                            title: "Pincode",
                            controller: _pinCodeController,
                          )
                          : _buildInfoRow(
                            Icons.pin_drop,
                            "Pincode",
                            _profile?.pinCode ?? "Not Available",
                          ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              StreamBuilder<List<DonationModel>>(
                stream: _donationService.getMyDonations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final donations = snapshot.data ?? [];

                  final total = donations.length;
                  final available =
                      donations.where((d) => d.status == "available").length;
                  final accepted =
                      donations.where((d) => d.status == "accepted").length;
                  final completed =
                      donations.where((d) => d.status == "completed").length;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Donation Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          _buildInfoRow(
                            Icons.volunteer_activism,
                            "Total",
                            total.toString(),
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            Icons.inventory,
                            "Available",
                            available.toString(),
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            Icons.handshake,
                            "Accepted",
                            accepted.toString(),
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            Icons.check_circle,
                            "Completed",
                            completed.toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
