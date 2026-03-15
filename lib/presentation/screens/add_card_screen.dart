import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../viewmodel/add_card_bloc.dart';
import '../event/add_card_event.dart';
import '../state/add_card_state.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F3E),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Добавление платежной карты'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),

                    // 🔹 ЛИЦЕВАЯ СТОРОНА
                    _buildFrontCard(context),

                    const SizedBox(height: 16),

                    // 🔹 ОБРАТНАЯ СТОРОНА
                    _buildBackCard(context),

                    const SizedBox(height: 16),

                    // 🔹 КНОПКА "ДОБАВИТЬ КАРТУ"
                    BlocBuilder<AddCardBloc, AddCardState>(
                      builder: (context, state) {
                        return Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: state.isFormValid
                                ? const LinearGradient(
                              colors: [Color(0xFF66E3C4), Color(0xFF4CD1B5)],
                            )
                                : null,
                            color: state.isFormValid ? null : const Color(0xFF2A2F5E),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: state.isFormValid
                                  ? () {
                                context.read<AddCardBloc>().add(
                                  AddCardSubmitted(
                                    cardNumber: state.cardNumber,
                                    expiryDate: state.expiryDate,
                                    cvv: state.cvv,
                                  ),
                                );
                              }
                                  : null,
                              borderRadius: BorderRadius.circular(24),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Добавить карту',
                                      style: TextStyle(
                                        color: state.isFormValid ? const Color(0xFF0A0F2E) : Colors.white54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: state.isFormValid ? const Color(0xFF0A0F2E).withOpacity(0.6) : Colors.white38,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: state.isFormValid ? const Color(0xFF0A0F2E).withOpacity(0.3) : Colors.white24,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: state.isFormValid ? const Color(0xFF0A0F2E).withOpacity(0.15) : Colors.white12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // 🔹 ТЕКСТ О БЕЗОПАСНОСТИ
                    const Text(
                      'Мы не сохраняем данные карты у себя. Оплата происходит через сертифицированный провайдер Беларуси bePaid. '
                          'Платежная страница системы bePaid отвечает требованиям безопасности передачи данных PCI DSS Level I. '
                          'Все конфиденциальные данные хранятся в зашифрованном виде.',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // 🔹 ЛОГОТИПЫ ПЛАТЁЖНЫХ СИСТЕМ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PaymentLogo(name: 'VISA', color: const Color(0xFF1A1F7A)),
                        const SizedBox(width: 12),
                        _PaymentLogo(name: 'MC', color: const Color(0xFFEB001B)),
                        const SizedBox(width: 12),
                        _PaymentLogo(name: 'BELCARD', color: const Color(0xFF00A650)),
                        const SizedBox(width: 12),
                        _PaymentLogo(name: 'VISA', color: const Color(0xFF1A1F7A)),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return BlocBuilder<AddCardBloc, AddCardState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F2E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F3E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Лицевая сторона',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Номер карты
              Text(
                'Номер карты',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                hintText: '0000 0000 0000 0000',
                value: state.cardNumber,
                icon: Icons.credit_card,
                onChanged: (value) {
                  context.read<AddCardBloc>().add(CardNumberChanged(value));
                },
              ),

              const SizedBox(height: 20),

              // Дата окончания
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дата окончания действия',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Месяц/Год:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 120,
                    child: _buildInputField(
                      hintText: '00 / 00',
                      value: state.expiryDate,
                      icon: Icons.calendar_today,
                      onChanged: (value) {
                        context.read<AddCardBloc>().add(ExpiryDateChanged(value));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackCard(BuildContext context) {
    return BlocBuilder<AddCardBloc, AddCardState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF050818),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F3E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Обратная сторона',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // CVV
              Text(
                'CVV',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 120,
                child: _buildInputField(
                  hintText: '000',
                  value: state.cvv,
                  icon: Icons.lock,
                  isPassword: true,
                  onChanged: (value) {
                    context.read<AddCardBloc>().add(CvvChanged(value));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String hintText,
    required String value,
    required IconData icon,
    required ValueChanged<String> onChanged,
    bool isPassword = false,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(hintText.contains('0000') ? 16 : 4),
              ],
              obscureText: isPassword,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 16,
                  letterSpacing: 2,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: Colors.white.withOpacity(0.5),
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _PaymentLogo extends StatelessWidget {
  final String name;
  final Color color;

  const _PaymentLogo({
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.credit_card,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}