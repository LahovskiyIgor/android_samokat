import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:by_happy/presentation/components/payment_option.dart';

// 🔹 МОДЕЛЬ ПЛАТЁЖНОЙ КАРТЫ
class PaymentCard {
  final int id;
  final String type;
  final String lastNumber;
  final bool isMain;

  PaymentCard({
    required this.id,
    required this.type,
    required this.lastNumber,
    this.isMain = false,
  });
}

class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({super.key});

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  int? _selectedPaymentMethod; // null - баланс, 0+ - индекс карты

  // 🔹 ЗАГЛУШКА: БАЛАНС
  final double _balance = 0.00;

  // 🔹 ЗАГЛУШКА: КАРТЫ
  final List<PaymentCard> _cards = [
    PaymentCard(
      id: 1,
      type: 'BelCard',
      lastNumber: '0012',
      isMain: true, // ← Эта карта будет выбрана по умолчанию
    ),
    PaymentCard(
      id: 2,
      type: 'Visa',
      lastNumber: '4532',
      isMain: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 🔹 Находим карту с isMain: true и устанавливаем её как выбранную
    _selectedPaymentMethod = _cards.indexWhere((card) => card.isMain);
    // Если ни одна карта не isMain, то выбран баланс (null)
    if (_selectedPaymentMethod == -1) {
      _selectedPaymentMethod = null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          subtitle: '${_balance.toStringAsFixed(2)} BYN',
                          isSelected: _selectedPaymentMethod == null,
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = null;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        // 🔹 КАРТЫ
                        ..._cards.asMap().entries.map((entry) {
                          final index = entry.key;
                          final card = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PaymentOption(
                              title: card.type,
                              subtitle: '****${card.lastNumber}',
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
  }
}

// 🔹 ВИДЖЕТ ОДНОЙ ПЛАТЁЖНОЙ ОПЦИИ
