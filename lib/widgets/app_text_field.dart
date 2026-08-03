import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;

  final String hint;
  final String? label;

  final String? prefixText;
  final IconData? prefixIcon;

  final bool showPrefix;
  final bool showPrefixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final int? maxLength;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.prefixText,
    this.prefixIcon,
    this.showPrefix = false,
    this.showPrefixIcon = false,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      cursorColor: AppColors.primary,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        counterText: "",

        labelText: label,
        labelStyle: AppTextStyles.bodySmall,

        hintText: hint,
        hintStyle: AppTextStyles.hint,

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),

        prefixIcon:
            showPrefixIcon && prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 18, right: 12),
                  child: Icon(prefixIcon, size: 22, color: AppColors.primary),
                )
                : null,

        prefixIconConstraints: const BoxConstraints(minWidth: 24),

        // +91 will always be visible now
        prefixText: showPrefix && prefixText != null ? "$prefixText " : null,

        prefixStyle: AppTextStyles.prefix,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
      ),
    );
  }
}
