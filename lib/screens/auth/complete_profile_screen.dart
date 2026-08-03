import 'package:flutter/material.dart';
import 'location_permission_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../features/auth/repository/profile_repository.dart';
import '../../features/location/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileRepository _profileRepository = ProfileRepository();

  final _nameController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _pinController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';

      final profile = UserProfile(
        name: _nameController.text.trim(),
        phoneNumber: phoneNumber,
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        pinCode: _pinController.text.trim(),
      );

      await _profileRepository.saveUserProfile(profile);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save profile: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: Form(
            key: _formKey,

            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const SizedBox(height: 35),

                  Center(
                    child: Text(
                      "Complete Your Profile",
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: SizedBox(
                      width: 290,
                      child: Text(
                        "Complete your profile to start sharing and receiving food in your community.",
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  //------------------------------------
                  // Full Name
                  //------------------------------------
                  AppTextField(
                    controller: _nameController,
                    hint: "Enter full name",
                    label: "Full Name *",

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter full name";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  //------------------------------------
                  // State
                  //------------------------------------
                  AppTextField(
                    controller: _stateController,
                    hint: "Enter state",
                    label: "State *",

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter state";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  //------------------------------------
                  // City
                  //------------------------------------
                  AppTextField(
                    controller: _cityController,
                    hint: "Enter city",
                    label: "City *",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter city";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  //------------------------------------
                  // Area / Locality
                  //------------------------------------
                  AppTextField(
                    controller: _areaController,
                    hint: "Enter area / locality",
                    label: "Area / Locality *",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter area / locality";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  //------------------------------------
                  // PIN Code
                  //------------------------------------
                  AppTextField(
                    controller: _pinController,
                    hint: "Enter PIN code",
                    label: "PIN Code *",
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter PIN code";
                      }

                      if (value.length != 6) {
                        return "PIN code must be 6 digits";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 36),

                  //------------------------------------
                  // Continue Button
                  //------------------------------------
                  PrimaryButton(
                    title: "Continue",
                    loading: isLoading,
                    onPressed: _continue,
                  ),

                  const SizedBox(height: 18),

                  //------------------------------------
                  // Helper Text
                  //------------------------------------
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Your profile information helps us connect you with nearby food donations.",
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
