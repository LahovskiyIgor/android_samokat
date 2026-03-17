import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:by_happy/presentation/components/payment_option.dart';

import '../../domain/entities/payment_card.dart';
import '../../event/payment_method_sheet_event.dart';
import '../../state/payment_method_sheet_state.dart';
import '../../viewmodel/payment_method_sheet_bloc.dart';

class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({super.key});

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  int? _selectedPaymentMethod; // null - баланс, 0+ - индекс карты

  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodSheetBloc>().add(PaymentMethodSheetStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodSheetBloc, PaymentMethodSheetState>(
      builder: (context, state) {
        if (state.status == PaymentMethodSheetStatus.loading) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    color: const Color(0x00000032).withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }

        if (state.status == PaymentMethodSheetStatus.failure) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    color: const Color(0x00000032).withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text(
                      state.errorMessage ?? 'Ошибка загрузки карт',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // Находим карту с isMain: true при загрузке
        if (_selectedPaymentMethod == null) {
          final mainCardIndex = state.cards.indexWhere((card) => card.isMain);
          if (mainCardIndex != -1) {
            _selectedPaymentMethod = mainCardIndex;
          }
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 450,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0x00000032).withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: const Color(0x99FFFFFF),
                                  size: 20,
                                ),
                                Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: const Color(0x66FFFFFF),
                                  size: 20,
                                ),
                                Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: const Color(0x22FFFFFF),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Выберите способ оплаты',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 СПИСОК СПОСОБОВ ОПЛАТЫ
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // 🔹 БАЛАНС (всегда первый)
                            PaymentOption(
                              title: 'Баланс',
                              subtitle: '${state.balance.toStringAsFixed(2)} BYN',
                              isSelected: _selectedPaymentMethod == null,
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = null;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            // 🔹 КАРТЫ
                            ...state.cards.asMap().entries.map((entry) {
                              final index = entry.key;
                              final card = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PaymentOption(
                                  title: _getCardType(card.cardLastNumber),
                                  subtitle: '****${card.cardLastNumber}',
                                  isSelected: _selectedPaymentMethod == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedPaymentMethod = index;
                                    });
                                  },
                                ),
                              );
                            }).toList(),

                            // 🔹 КНОПКА "ДОБАВИТЬ КАРТУ"
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.go('/home/add-card');
                                  },
                                  borderRadius: BorderRadius.circular(24),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: const Color(0xFF66E3C4),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Добавить платежную карту',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getCardType(String lastNumber) {
    if (lastNumber.isEmpty) return 'Card';
    final firstDigit = lastNumber[0];
    switch (firstDigit) {
      case '4':
        return 'Visa';
      case '5':
        return 'Mastercard';
      case '9':
        return 'BelCard';
      default:
        return 'Card';
    }
  }
}
