class Tariff {
  final int id;
  final String title;
  final String description;
  final bool isActive;
  final String currency;
  final double holdPrice;      // Старт / бронь
  final double drivePrice;     // Цена минуты
  final double pausePrice;     // Пауза

  Tariff({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.currency,
    required this.holdPrice,
    required this.drivePrice,
    required this.pausePrice,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) {
    final planPrice = json['planPrice'] as Map<String, dynamic>? ?? {};
    final currency = json['currency'] as Map<String, dynamic>? ?? {};

    return Tariff(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      currency: currency['code'] ?? currency['currency'] ?? 'RUB',
      holdPrice: (planPrice['hold'] as num?)?.toDouble() ?? 0.0,
      drivePrice: (planPrice['drive'] as num?)?.toDouble() ?? 0.0,
      pausePrice: (planPrice['pause'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Tariff{id: $id, title: $title, isActive: $isActive}';
  }
}
