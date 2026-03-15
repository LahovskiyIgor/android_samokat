import 'package:flutter/material.dart';
import '../../core/app_colors.dart';


class CodeDots extends StatelessWidget {
  final String code;
  final int length;
  final bool isError;


  const CodeDots({
    super.key,
    required this.code,
    required this.length,
    this.isError = false,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        bool filled = i < code.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            filled ? code[i] : '●',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isError
                  ? AppColors.pinError
                  : filled
                  ? AppColors.smsDigit
                  : AppColors.digitPlaceholder,
            ),
          ),
        );
      }),
    );
  }
}