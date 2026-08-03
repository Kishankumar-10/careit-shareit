import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final bool enabled;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.height = 58,
    this.borderRadius = 20,
    this.margin,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !enabled || loading;

    return Container(
      margin: margin,
      width: double.infinity,
      height: height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.grey.shade400,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
        ),

        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),

          child: loading
              ? const SizedBox(
                  key: ValueKey("loading"),

                  width: 24,
                  height: 24,

                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : Row(
                  key: const ValueKey("text"),

                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 20,
                      ),

                      const SizedBox(width: 10),
                    ],

                    Text(
                      title,
                      style: AppTextStyles.button,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}