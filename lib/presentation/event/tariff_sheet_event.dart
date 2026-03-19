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

class BookScooterPressed extends TariffSheetEvent {
  final int scooterId;
  final int planId;
  final int? subscriptionId;
  final int? cardId;
  final bool isBalance;
  final bool isInsurance;

  BookScooterPressed(this.scooterId, this.planId, this.subscriptionId,
      this.cardId, this.isBalance, this.isInsurance);


}
