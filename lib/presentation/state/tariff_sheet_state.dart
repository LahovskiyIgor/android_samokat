import 'package:by_happy/domain/entities/payment_card.dart';

import '../../domain/entities/tariff.dart';

enum TariffSheetStatus { initial, loading, success, failure }

class TariffSheetState {
  final TariffSheetStatus status;
  final List<Tariff> tariffs;
  final String? errorMessage;
  final PaymentCard? selectedCard;

  TariffSheetState({
    this.status = TariffSheetStatus.initial,
    this.tariffs = const [],
    this.selectedCard,
    this.errorMessage,
  });

  TariffSheetState copyWith({
    TariffSheetStatus? status,
    List<Tariff>? tariffs,
    PaymentCard? selectedCard,
    String? errorMessage,
  }) => TariffSheetState(
    status: status ?? this.status,
    tariffs: tariffs ?? this.tariffs,
    selectedCard: selectedCard ?? this.selectedCard,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
