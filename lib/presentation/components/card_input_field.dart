import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final int? maxLength;
  final double letterSpacing;
  final TextCapitalization textCapitalization; // ← новый параметр

  const CardInputField({
    super.key,
    required this.hintText,
    this.icon,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.obscureText = false,
    this.maxLength,
    this.letterSpacing = 0,
    this.textCapitalization = TextCapitalization.none, // ← по умолчанию none
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              obscureText: obscureText,
              maxLength: maxLength,
              textCapitalization: textCapitalization, // ← передаём в TextField
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: letterSpacing,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 16,
                  letterSpacing: letterSpacing,
                ),
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 12),
            Icon(
              icon,
              color: Colors.white.withOpacity(0.6),
              size: 22,
            ),
          ],
        ],
      ),
    );
  }
}