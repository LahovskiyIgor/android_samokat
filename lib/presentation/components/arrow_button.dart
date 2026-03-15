import 'package:flutter/material.dart';
import '../../core/app_colors.dart';


class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool enabled;


  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 350, // Максимальная ширина кнопки
        ),
        height: 66,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: enabled ? AppColors.activeButtonGradient : null,
          color: enabled ? null : AppColors.disabledButtonColor,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: enabled ? AppColors.activeButtonText : AppColors.disabledButtonText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}