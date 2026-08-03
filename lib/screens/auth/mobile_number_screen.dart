import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_screen.dart';
import '../../../features/auth/repository/auth_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();
  bool isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await _authRepository.sendOtp(
      phoneNumber: "+91${_phoneController.text.trim()}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android can automatically verify the OTP in some cases.
        // We'll handle automatic sign-in in the next step.
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "OTP verification failed")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => OtpVerificationScreen(
                  mobileNumber: "+91${_phoneController.text.trim()}",
                  verificationId: verificationId,
                ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // We'll use this later if needed.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      media.size.height -
                      media.padding.top -
                      media.padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      //-----------------------------------------
                      // Back Button
                      //-----------------------------------------
                      const SizedBox(height: 20),

                      //-----------------------------------------
                      // Logo
                      //-----------------------------------------
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Image.asset(
                              "assets/careitshareit_logo01.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      //-----------------------------------------
                      // Welcome
                      //-----------------------------------------
                      Text("Welcome", style: AppTextStyles.heading),

                      const SizedBox(height: 10),

                      Text(
                        "Enter your mobile number to continue.\nWe'll send you a verification code.",
                        style: AppTextStyles.subtitle,
                      ),

                      const SizedBox(height: 38),

                      //-----------------------------------------
                      // Phone TextField
                      //-----------------------------------------
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        cursorColor: AppColors.primary,
                        style: AppTextStyles.inputText,

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter mobile number";
                          }

                          if (value.trim().length != 10) {
                            return "Enter valid mobile number";
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "9876543210",
                          hintStyle: AppTextStyles.hint,

                          filled: true,
                          fillColor: Colors.white,

                          contentPadding: EdgeInsets.zero,

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: AppColors.error,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: AppColors.error,
                              width: 2,
                            ),
                          ),

                          prefixIcon: Container(
                            width: 120,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),

                                const SizedBox(width: 12),

                                Text("+91", style: AppTextStyles.prefix),

                                const SizedBox(width: 12),

                                Container(
                                  width: 1,
                                  height: 24,
                                  color: AppColors.divider,
                                ),
                              ],
                            ),
                          ),

                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 120,
                            maxWidth: 120,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      //-----------------------------------------
                      // Continue Button
                      //-----------------------------------------
                      PrimaryButton(
                        title: "Continue",
                        loading: isLoading,
                        onPressed: _continue,
                      ),

                      const SizedBox(height: 18),

                      //-----------------------------------------
                      // OTP Info
                      //-----------------------------------------
                      Center(
                        child: Text(
                          "We'll send a One Time Password (OTP)",
                          style: AppTextStyles.smallGrey,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const Spacer(),

                      //-----------------------------------------
                      // Terms & Conditions
                      //-----------------------------------------
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, top: 24),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.terms,
                              children: [
                                const TextSpan(
                                  text: "By continuing, you agree to our ",
                                ),
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: AppTextStyles.link,
                                ),
                                const TextSpan(text: "\nand "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: AppTextStyles.link,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
