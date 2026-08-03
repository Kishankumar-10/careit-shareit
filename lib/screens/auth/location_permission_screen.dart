import 'package:careit_shareit/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../../core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  Future<void> _allowLocation() async {
    try {
      // Check if GPS is enabled
      bool serviceEnabled =
          await LocationService.instance.isLocationServiceEnabled();

      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services.")),
        );
        return;
      }

      // Check current permission
      LocationPermission permission =
          await LocationService.instance.checkPermission();

      // Request permission if needed
      if (permission == LocationPermission.denied) {
        permission = await LocationService.instance.requestPermission();
      }

      // Permission permanently denied
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission is permanently denied."),
          ),
        );
        return;
      }

      // Permission denied
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }

      // Fetch current location
      final currentLocation = await LocationService.instance.getUserLocation();

      debugPrint(
        "Current Location: ${currentLocation.city}, ${currentLocation.state}",
      );

      // Navigate to Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(currentLocation: currentLocation),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildFeature(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),

          const SizedBox(width: 14),

          Expanded(child: Text(title, style: AppTextStyles.body)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

            child: Column(
              children: [
                const SizedBox(height: 7),

                //----------------------------------
                // Location Illustration
                //----------------------------------
                Center(
                  child: Container(
                    width: 180,
                    height: 180,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Center(
                      child: Container(
                        width: 140,
                        height: 140,

                        decoration: BoxDecoration(
                          color: AppColors.background,

                          shape: BoxShape.circle,

                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: const Icon(
                          Icons.location_on,
                          size: 72,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 42),

                //----------------------------------
                // Title
                //----------------------------------
                Text(
                  "Enable Location",
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 18),

                Text(
                  "Your location helps us discover nearby food donations and connect you with people within a 5 km radius. Your exact location will only be shared after both donor and receiver accept a request.",
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 34),

                //----------------------------------
                // Benefits Card
                //----------------------------------
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      _buildFeature(
                        Icons.check_circle,
                        "Discover nearby food donations",
                      ),

                      _buildFeature(Icons.check_circle, "Reduce travel time"),

                      _buildFeature(Icons.check_circle, "Faster food pickup"),

                      _buildFeature(Icons.security, "Privacy protected"),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                //----------------------------------
                // Allow Location Button
                //----------------------------------
                PrimaryButton(
                  title: "Allow Location Access",
                  onPressed: _allowLocation,
                ),

                const SizedBox(height: 16),

                //----------------------------------
                // Not Now Button
                //----------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: TextButton(
                    onPressed: () {
                      // TODO:
                      // Navigate to Home Screen
                      // without location permission
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Not Now",
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                //----------------------------------
                // Bottom Helper Text
                //----------------------------------
                Text(
                  "You can change this anytime from Settings.",
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
