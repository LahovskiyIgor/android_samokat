import 'dart:ui';
import 'package:by_happy/presentation/components/payment_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/scooter.dart';
import '../../../domain/entities/tariff.dart';
import '../../event/tariff_sheet_event.dart';
import '../../state/tariff_sheet_state.dart';
import '../../viewmodel/tariff_sheet_bloc.dart';
import '../gradient_button.dart';
import '../scooter/mini_battery_indicator.dart';

class TariffSheet extends StatefulWidget {
  final Scooter scooter;

  const TariffSheet({
    super.key,
    required this.scooter,
  });

  @override
  State<TariffSheet> createState() => _TariffSheetState();
}

class _TariffSheetState extends State<TariffSheet> {
  int? _selectedTariffIndex;
  bool _hasPaymentCard = true;

  @override
  void initState() {
    super.initState();
    context.read<TariffSheetBloc>().add(TariffSheetStarted(widget.scooter.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TariffSheetBloc, TariffSheetState>(
      builder: (context, state) {
        if (state.status == TariffSheetStatus.loading) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 520,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000032).withOpacity(0.88),
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

        if (state.status == TariffSheetStatus.failure) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 520,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000032).withOpacity(0.88),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text(
                      state.errorMessage ?? 'Ошибка загрузки тарифов',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 520,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF000032).withOpacity(0.88),
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
                              'Самокат ${widget.scooter.number}',
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

                    // 🔹 БАТАРЕЯ + ИНФО
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 80,
                            child: Image.asset(
                              'assets/icons/e6a5dcb6a3e2ec2362c25ea49509ab10d2312b19-reverse.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  MiniBatteryIndicator(percent: widget.scooter.batteryLevel),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Заряда хватит на 4 часа 17 минут\nили 47 км',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 ТАРИФЫ (горизонтальный скролл)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: state.tariffs.length,
                        itemBuilder: (context, index) {
                          final tariff = state.tariffs[index];
                          return Row(
                            children: [
                              _TariffCard(
                                title: tariff.title,
                                price: tariff.holdPrice.toStringAsFixed(0),
                                currency: tariff.currency,
                                subtitle: 'Старт поездки',
                                details: [
                                  'Далее  ${tariff.drivePrice.toStringAsFixed(2)} ${tariff.currency}/мин.',
                                  'Минута на паузе  ${tariff.pausePrice.toStringAsFixed(0)} ${tariff.currency}',
                                ],
                                isSelected: _selectedTariffIndex == index,
                                onTap: () {
                                  setState(() {
                                    _selectedTariffIndex = index;
                                  });
                                },
                              ),
                              if (index < state.tariffs.length - 1)
                                const SizedBox(width: 12),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    state.mainCard != null ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PaymentOption(
                          title: "Mastercard",  //добавить проверку по первой цифре
                          subtitle: '****${state.mainCard!.cardLastNumber}',
                          isSelected: true,
                          onTap: () {
                            setState(() {
                              // _selectedPaymentMethod = index;
                            });
                          },
                        ),
                      ) :

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
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
                              // TODO: Открыть экран выбора способа оплаты
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Способ оплаты',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🔹 КНОПКА "ЗАБРОНИРОВАТЬ"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GradientButton(
                        text: 'Забронировать',
                        showArrows: true,
                        height: 56,
                        width: double.infinity,
                        fontSize: 16,
                        enabled: _selectedTariffIndex != null && _hasPaymentCard,
                        onTap: (_selectedTariffIndex != null && _hasPaymentCard)
                            ? () {
                          // TODO: Забронировать самокат
                        }
                            : null,
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
}

class _TariffCard extends StatelessWidget {
  final String title;
  final String price;
  final String currency;
  final String subtitle;
  final List<String> details;
  final bool isSelected;
  final VoidCallback onTap;

  const _TariffCard({
    required this.title,
    required this.price,
    required this.currency,
    required this.subtitle,
    required this.details,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // 🔹 Фон темнее при выборе
          color: isSelected
              ? const Color(0xFF1A1F3E)  // тёмный фон
              : Colors.white.withOpacity(0.19),
          borderRadius: BorderRadius.circular(20),
          // 🔹 Убираем рамку полностью
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Заголовок с иконкой часов
            Row(
              children: [
                // Иконка часов вместо кружка
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: const Color(0xFF66E3C4),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF66E3C4),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Цена + текст рядом
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$price $currency',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // Детали
            ...details.map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                detail,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 12,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}