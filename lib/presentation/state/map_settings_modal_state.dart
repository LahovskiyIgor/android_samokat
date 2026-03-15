class MapSettingsModalState {
  final bool isAllGeomarksActive;
  final bool isAllGeozonesActive;
  final bool isRestrictedDrivingZoneActive;
  final bool isParkingZoneActive;
  final bool isRestrictedParkingZoneActive;

  MapSettingsModalState({
    required this.isAllGeomarksActive,
    required this.isAllGeozonesActive,
    required this.isRestrictedDrivingZoneActive,
    required this.isParkingZoneActive,
    required this.isRestrictedParkingZoneActive,
  });

  MapSettingsModalState copyWith({
    bool? isGeomarksActive,
    bool? isAllGeozonesActive,
    bool? isRestrictedDrivingZoneActive,
    bool? isParkingZoneActive,
    bool? isRestrictedParkingZoneActive,
  }) => MapSettingsModalState(
    isAllGeomarksActive: isGeomarksActive ?? this.isAllGeomarksActive,
    isAllGeozonesActive: isAllGeozonesActive ?? this.isAllGeozonesActive,
    isRestrictedDrivingZoneActive: isRestrictedDrivingZoneActive ?? this.isRestrictedDrivingZoneActive,
    isParkingZoneActive: isParkingZoneActive ?? this.isParkingZoneActive,
    isRestrictedParkingZoneActive: isRestrictedParkingZoneActive ?? this.isRestrictedParkingZoneActive,
  );
}
