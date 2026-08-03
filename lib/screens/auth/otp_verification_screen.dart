import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'complete_profile_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/otp_input_field.dart';
import '../../widgets/primary_button.dart';
import '../../../features/auth/repository/auth_repository.dart';
import '../../../features/auth/repository/profile_repository.dart';
import '../../screens/home_screen.dart';


class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final String verificationId;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  bool isLoading = false;

  int seconds = 30;

  Timer? timer;
  final AuthRepository _authRepository = AuthRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  void initState() {
    super.initState();

    controllers = List.generate(6, (_) => TextEditingController());

    focusNodes = List.generate(6, (_) => FocusNode());

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();

    for (final c in controllers) {
      c.dispose();
    }

    for (final f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  void startTimer() {
    timer?.cancel();

    seconds = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  String get otp => controllers.map((e) => e.text).join();

  Future<void> verifyOtp() async {
    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter the OTP")));
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await _authRepository.verifyOtp(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      setState(() {
        isLoading = false;
      });

      final profile = await _profileRepository.getUserProfile();

      if (!mounted) return;

      if (profile == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Invalid OTP")));
    }

    // TODO:
    // Verify OTP using Firebase/Auth API

    // Navigator.pushReplacement(...)
  }

  void resendOtp() {
    startTimer();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("OTP sent successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 10),

                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),

                const SizedBox(height: 40),

                Text("Verify OTP", style: AppTextStyles.heading),

                const SizedBox(height: 10),

                RichText(
                  text: TextSpan(
                    style: AppTextStyles.subtitle,

                    children: [
                      const TextSpan(text: "Enter the 6-digit OTP sent to\n"),
                      TextSpan(
                        text: widget.mobileNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  children: List.generate(
                    6,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OtpInputField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          index: index,
                          controllers: controllers,
                          focusNodes: focusNodes,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                PrimaryButton(
                  title: "Verify & Continue",
                  loading: isLoading,
                  onPressed: verifyOtp,
                ),

                const SizedBox(height: 30),
                Center(
                  child:
                      seconds > 0
                          ? RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodySmall,
                              children: [
                                const TextSpan(text: "Resend OTP in "),
                                TextSpan(
                                  text:
                                      "00:${seconds.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : TextButton(
                            onPressed: resendOtp,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              "Resend OTP",
                              style: AppTextStyles.link,
                            ),
                          ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    "Didn't receive the code?",
                    style: AppTextStyles.smallGrey,
                  ),
                ),

                const Spacer(),

                Center(
                  child: Text(
                    "The OTP is valid for 30 seconds.",
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
