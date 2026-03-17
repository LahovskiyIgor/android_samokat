import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/card_input_field.dart'; // ← новый импорт
import '../viewmodel/add_card_bloc.dart';
import '../event/add_card_event.dart';
import '../state/add_card_state.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 ВЕРХНЯЯ ЧАСТЬ (шапка + форма)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const CustomAppBar(title: 'Добавление карты'),
                      const SizedBox(height: 24),

                      // 🔹 ОСНОВНОЙ КОНТЕЙНЕР С ПОЛЯМИ
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0F2E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Номер карты
                            BlocBuilder<AddCardBloc, AddCardState>(
                              builder: (context, state) {
                                return CardInputField(
                                  hintText: '0000 0000 0000 0000',
                                  icon: Icons.credit_card,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                  ],
                                  letterSpacing: 2,
                                  onChanged: (value) {
                                    context.read<AddCardBloc>().add(CardNumberChanged(value));
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            // Срок действия и CVV (рядом)
                            Row(
                              children: [
                                Expanded(
                                  child: BlocBuilder<AddCardBloc, AddCardState>(
                                    builder: (context, state) {
                                      return CardInputField(
                                        hintText: 'MM/YY',
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        onChanged: (value) {
                                          context.read<AddCardBloc>().add(ExpiryDateChanged(value));
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: BlocBuilder<AddCardBloc, AddCardState>(
                                    builder: (context, state) {
                                      return CardInputField(
                                        hintText: 'CVV',
                                        obscureText: true,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        onChanged: (value) {
                                          context.read<AddCardBloc>().add(CvvChanged(value));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Имя и фамилия на карте
                            BlocBuilder<AddCardBloc, AddCardState>(
                              builder: (context, state) {
                                return CardInputField(
                                  hintText: 'Имя и фамилия на карте',
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (value) {
                                    context.read<AddCardBloc>().add(CardHolderChanged(value));
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // 🔹 КНОПКА "ДОБАВИТЬ КАРТУ"
                            BlocBuilder<AddCardBloc, AddCardState>(
                              builder: (context, state) {
                                return Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.white.withOpacity(0.15),
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
                                            cardHolder: state.cardHolder,
                                          ),
                                        );
                                      }
                                          : null,
                                      borderRadius: BorderRadius.circular(24),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: state.isFormValid
                                                  ? const Color(0xFF66E3C4)
                                                  : Colors.white.withOpacity(0.3),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Добавить карту',
                                              style: TextStyle(
                                                color: state.isFormValid
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(0.3),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    // Текст о безопасности
                    const Text(
                      'Мы не сохраняем данные карты у себя. Оплата происходит '
                          'через сертифицированный провайдер Беларуси bePaid. '
                          'Платежная страница системы bePaid отвечает требованиям '
                          'безопасности передачи данных PCI DSS Level I. '
                          'Все конфиденциальные данные хранятся в зашифрованном виде.',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 24),

                    // Логотипы платёжных систем

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
