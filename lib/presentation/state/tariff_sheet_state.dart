import '../../domain/entities/tariff.dart';

enum TariffSheetStatus { initial, loading, success, failure }

class TariffSheetState {
  final TariffSheetStatus status;
  final List<Tariff> tariffs;
  final String? errorMessage;

  TariffSheetState({
    this.status = TariffSheetStatus.initial,
    this.tariffs = const [],
    this.errorMessage,
  });

  TariffSheetState copyWith({
    TariffSheetStatus? status,
    List<Tariff>? tariffs,
    String? errorMessage,
  }) => TariffSheetState(
    status: status ?? this.status,
    tariffs: tariffs ?? this.tariffs,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
