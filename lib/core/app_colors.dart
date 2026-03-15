import 'package:flutter/material.dart';

class AppColors {
  // --------------------------
  // ФОНЫ ЭКРАНОВ
  // --------------------------

  /// Градиент PhoneScreen (ввод телефона)
  static const LinearGradient phoneScreenBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF293A69),
      Color(0xFF202741),
    ],
  );

  /// Градиент PhoneLoginScreen & PinLoginScreen
  static const LinearGradient authScreenBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D1A44),
      Color(0xFF091233),
    ],
  );

  // --------------------------
  // КНОПКИ
  // --------------------------

  /// Активная кнопка — бирюзово-зелёный градиент
  static const LinearGradient activeButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF75FBF0),
      Color(0xFF8BFFAA),
    ],
  );

  /// Неактивная кнопка — тёмно-синий
  static const Color disabledButtonColor = Color(0xFF2A3A6A);

  /// Активный текст кнопки
  static const Color activeButtonText = Color(0xFF000032);

  /// Неактивный текст кнопки
  static const Color disabledButtonText = Color(0x99FFFFFF);

  // --------------------------
  // ЦВЕТА ДЛЯ TOGGLE / CHECKBOX
  // --------------------------

  /// Бордер неактивного чекбокса
  static const Color checkboxBorder = Colors.white70;

  /// Бордер чекбокса с ошибкой
  static const Color checkboxErrorBorder = Color(0xFFBA1A1A);

  /// Цвет заливки активного чекбокса
  static const Color checkboxFill = Color(0xFF8BFFAA);

  // --------------------------
  // PIN / CODE INPUT
  // --------------------------

  /// Цвет цифры в SMS-коде (PhoneLoginScreen)
  static const Color smsDigit = Color(0xFF75FBF0);

  /// Цвет точки-плейсхолдера
  static const Color digitPlaceholder = Color(0x66FFFFFF);

  /// Цвет правильного PIN
  static const Color pinSuccess = Color(0xFF66FF99);

  /// Цвет неверного PIN
  static const Color pinError = Color(0xFFFF4F4F);

  // --------------------------
  // ТЕКСТ
  // --------------------------

  static const Color whiteText = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color hint = Colors.white54;

  // --------------------------
  // ПРОЧЕЕ
  // --------------------------

  static const Color darkBlue = Color(0xFF000032);
}
