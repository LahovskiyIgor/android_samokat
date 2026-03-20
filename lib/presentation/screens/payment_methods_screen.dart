import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';

// 🔹 МОДЕЛЬ КАРТЫ (как с бэка)
class PaymentCard {
  final int id;
  final String type;           // 'BelCard', 'Visa', 'Mastercard'
  final String maskedNumber;   // '****0012'
  final bool isMain;
  final String? iconPath;      // Путь к иконке (опционально)

  PaymentCard({
    required this.id,
    required this.type,
    required this.maskedNumber,
    this.isMain = false,
    this.iconPath,
  });
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // 🔹 ЗАГЛУШКА: СПИСОК КАРТ (будет приходить с бэка)
  final List<PaymentCard> _cards = [
    PaymentCard(
      id: 1,
      type: 'BelCard',
      maskedNumber: '****0012',
      isMain: true,
      iconPath: 'assets/icons/belcard.png',
    ),
    PaymentCard(
      id: 2,
      type: 'Mastercard',
      maskedNumber: '****8532',
      isMain: false,
      iconPath: 'assets/icons/mastercard.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppBar(title: 'Способы оплаты'),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 🔹 БАЛАНС
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.activeButtonGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Баланс',
                                  style: TextStyle(
                                    color: Color(0xFF0A0F2E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      '0,00',
                                      style: TextStyle(
                                        color: Color(0xFF0A0F2E),
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'баллов',
                                      style: TextStyle(
                                        color: const Color(0xFF0A0F2E).withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              right: -30,
                              top: -50,
                              child: Image.asset(
                                'assets/icons/card-screen.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 СПИСОК КАРТ
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0F2E).withOpacity(0.65),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Карты',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 🔹 РЕНДЕР СПИСКА КАРТ ИЗ МАССИВА
                            ..._cards.asMap().entries.map((entry) {
                              final index = entry.key;
                              final card = entry.value;
                              return Column(
                                children: [
                                  _CardItem(
                                    card: card,
                                    onDelete: () {
                                      // TODO: Удалить карту с бэка
                                    },
                                    onMakeMain: () {
                                      // TODO: Сделать карту основной
                                    },
                                  ),
                                  // Добавляем отступ только между картами
                                  if (index < _cards.length - 1)
                                    const SizedBox(height: 16),
                                ],
                              );
                            }).toList(),

                            const SizedBox(height: 20),

                            // 🔹 КНОПКА "ПРИВЯЗАТЬ КАРТУ"
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A0F2E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context.go('/home/payment-methods/add-card');
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.credit_card,
                                          color: const Color(0xFF00D4AA),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'Привязать карту',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.add,
                                          color: const Color(0xFF00D4AA),
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 ВИДЖЕТ ОДНОЙ КАРТЫ
class _CardItem extends StatelessWidget {
  final PaymentCard card;
  final VoidCallback onDelete;
  final VoidCallback onMakeMain;

  const _CardItem({
    required this.card,
    required this.onDelete,
    required this.onMakeMain,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Иконка карты
        Image.asset(
          card.iconPath ?? _getDefaultIconPath(card.type),
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        // Информация о карте
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${card.type} ${card.maskedNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                card.isMain ? 'основная' : 'сделать основной',
                style: TextStyle(
                  color: card.isMain ? const Color(0xFF66E3C4) : Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Кнопка удаления (X)
        GestureDetector(
          onTap: onDelete,
          child: const Icon(
            Icons.close,
            color: Color(0xFF00D4AA),
            size: 20,
          ),
        ),
      ],
    );
  }

  String _getDefaultIconPath(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'belcard':
        return 'assets/icons/belcard.png';
      case 'mastercard':
        return 'assets/icons/mastercard.png';
      case 'visa':
        return 'assets/icons/visa.png';
      default:
        return 'assets/icons/visa.png';
    }
  }
}