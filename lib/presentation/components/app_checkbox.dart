import 'package:flutter/material.dart';
import '../../core/app_colors.dart';


class AppCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final bool isError;


  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isError = false,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isError ? AppColors.checkboxErrorBorder : AppColors.checkboxBorder,
            width: 2,
          ),
          color: value ? AppColors.checkboxFill : Colors.transparent,
        ),
        child: value
            ? const Icon(
          Icons.check,
          size: 16,
          color: Color(0xFF000032),
        )
            : null,
      ),
    );
  }
}