import 'package:by_happy/domain/entities/payment_card.dart';

sealed class TariffSheetEvent {}

class TariffSheetStarted extends TariffSheetEvent {
  final int scooterId;

  TariffSheetStarted(this.scooterId);
}

class PaymentCardChanged extends TariffSheetEvent {
  final PaymentCard card;

  PaymentCardChanged(this.card);
}
