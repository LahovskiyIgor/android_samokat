// import 'package:flutter/material.dart';
// import '../core/app_colors.dart';
//
//
// class GradientButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onTap;
//   final bool enabled;
//
//
//   const GradientButton({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.enabled = true,
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: enabled ? onTap : null,
//       child: Container(
//         constraints: const BoxConstraints(
//           maxWidth: 350, // Максимальная ширина кнопки
//         ),
//         height: 66,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           gradient: enabled ? AppColors.activeButtonGradient : null,
//           color: enabled ? null : AppColors.disabledButtonColor,
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: enabled ? AppColors.activeButtonText : AppColors.disabledButtonText,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool enabled;
  final bool showArrows; // Новый параметр для стрелок
  final double height;    // Параметр высоты
  final double width;
  final double fontSize; // Параметр размера шрифта

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
    this.showArrows = false,
    this.width = 220,
    this.height = 50,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final Color arrow1 = enabled ? const Color(0x33000032) : const Color(0x33FFFFFF);
    final Color arrow2 = enabled ? const Color(0x66000032) : const Color(0x66FFFFFF);
    final Color arrow3 = enabled ? const Color(0x99000032) : const Color(0x99FFFFFF);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: enabled ? AppColors.activeButtonGradient : null,
          color: enabled ? null : AppColors.disabledButtonColor,
        ),
        alignment: Alignment.center,
        child: showArrows
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: enabled ? AppColors.activeButtonText : AppColors.disabledButtonText,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 20),
            Icon(Icons.arrow_forward_ios_sharp, color: arrow1, size: 12),
            Icon(Icons.arrow_forward_ios_sharp, color: arrow2, size: 12),
            Icon(Icons.arrow_forward_ios_sharp, color: arrow3, size: 12),
          ],
        )
            : Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: enabled ? AppColors.activeButtonText : AppColors.disabledButtonText,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}