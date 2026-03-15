sealed class MapSettingsModalEvent {}

class AllGeomarksToggled extends MapSettingsModalEvent {
  final bool value;
  AllGeomarksToggled(this.value);
}

class AllGeozonesToggled extends MapSettingsModalEvent {
  final bool value;
  AllGeozonesToggled(this.value);
}

class RestrictedDrivingZonesToggled extends MapSettingsModalEvent {
  final bool value;
  RestrictedDrivingZonesToggled(this.value);
}

class RestrictedParkingZonesToggled extends MapSettingsModalEvent {
  final bool value;
  RestrictedParkingZonesToggled(this.value);
}

class ParkingZonesToggled extends MapSettingsModalEvent {
  final bool value;
  ParkingZonesToggled(this.value);
}

class ApllyButtonClick extends MapSettingsModalEvent {}

class MapSettingsModalStarted extends MapSettingsModalEvent {}



