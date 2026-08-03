import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  //========================================================
  // Large Heading
  //========================================================

  static const TextStyle heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
  );

  //========================================================
  // Screen Title
  //========================================================

  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Section Title
  //========================================================

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Subtitle
  //========================================================

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  //========================================================
  // Body
  //========================================================

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Small Body
  //========================================================

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  //========================================================
  // Button
  //========================================================

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  //========================================================
  // Input Text
  //========================================================

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Hint Text
  //========================================================

  static const TextStyle hint = TextStyle(
    fontSize: 16,
    color: AppColors.textHint,
    fontWeight: FontWeight.w400,
  );

  //========================================================
  // Phone Prefix
  //========================================================

  static const TextStyle prefix = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Small Grey Text
  //========================================================

  static const TextStyle smallGrey = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  //========================================================
  // Caption
  //========================================================

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  //========================================================
  // Link
  //========================================================

  static const TextStyle link = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  //========================================================
  // Terms
  //========================================================

  static const TextStyle terms = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  //========================================================
  // Card Title
  //========================================================

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Card Subtitle
  //========================================================

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  //========================================================
  // Profile Name
  //========================================================

  static const TextStyle profileName = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  //========================================================
  // Badge Text
  //========================================================

  static const TextStyle badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  //========================================================
  // OTP Text
  //========================================================

  static const TextStyle otp = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 2,
  );
}