import 'package:by_happy/domain/entities/payment_card.dart';

import '../../domain/entities/tariff.dart';

enum TariffSheetStatus { initial, loading, success, failure }

class TariffSheetState {
  final TariffSheetStatus status;
  final List<Tariff> tariffs;
  final String? errorMessage;
  final PaymentCard? mainCard;

  TariffSheetState({
    this.status = TariffSheetStatus.initial,
    this.tariffs = const [],
    this.mainCard,
    this.errorMessage,
  });

  TariffSheetState copyWith({
    TariffSheetStatus? status,
    List<Tariff>? tariffs,
    PaymentCard? mainCard,
    String? errorMessage,
  }) => TariffSheetState(
    status: status ?? this.status,
    tariffs: tariffs ?? this.tariffs,
    mainCard: mainCard ?? this.mainCard,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
