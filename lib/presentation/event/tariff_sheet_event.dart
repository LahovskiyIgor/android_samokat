sealed class TariffSheetEvent {}

class TariffSheetStarted extends TariffSheetEvent {
  final int scooterId;

  TariffSheetStarted(this.scooterId);
}
