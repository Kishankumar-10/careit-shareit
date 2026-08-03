import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int index;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.controllers,
    required this.focusNodes,
    required this.index,
  });

  void _handleChanged(BuildContext context, String value) {
    // -----------------------------
    // Handle OTP Paste
    // -----------------------------
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');

      for (int i = 0; i < digits.length && i < controllers.length; i++) {
        controllers[i].text = digits[i];
      }

      if (digits.length == controllers.length) {
        FocusScope.of(context).unfocus();
      } else {
        focusNodes[digits.length].requestFocus();
      }

      return;
    }

    // -----------------------------
    // Move to next field
    // -----------------------------
    if (value.isNotEmpty) {
      if (index < focusNodes.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }

    // -----------------------------
    // Move back on delete
    // -----------------------------
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,

        keyboardType: TextInputType.number,

        textInputAction: TextInputAction.next,

        textAlign: TextAlign.center,

        style: AppTextStyles.otp,

        maxLength: 1,

        onChanged: (value) {
          _handleChanged(context, value);
        },

        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        decoration: InputDecoration(
          counterText: "",

          filled: true,
          fillColor: Colors.white,

          contentPadding: EdgeInsets.zero,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.error),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.error, width: 1.6),
          ),
        ),
      ),
    );
  }
}
