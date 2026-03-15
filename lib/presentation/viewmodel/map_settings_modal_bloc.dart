import 'dart:async';

import 'package:by_happy/domain/entities/map_settings.dart';
import 'package:by_happy/domain/usecase/get_map_settings_usecase.dart';
import 'package:by_happy/domain/usecase/get_pedestrian_routes_usecase.dart';
import 'package:by_happy/domain/usecase/get_scooter_usecase.dart';
import 'package:by_happy/domain/usecase/save_map_settings_usecase.dart';
import 'package:by_happy/presentation/event/map_settings_modal_event.dart';
import 'package:by_happy/presentation/state/map_settings_modal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapSettingsModalBloc extends Bloc<MapSettingsModalEvent, MapSettingsModalState> {
  final GetMapSettingsUsecase getMapSettingsUsecase;
  final SaveMapSettingsUsecase saveMapSettingsUsecase;

  MapSettingsModalBloc(this.getMapSettingsUsecase, this.saveMapSettingsUsecase)
      : super(MapSettingsModalState(
    isAllGeomarksActive: true,
    isAllGeozonesActive: true,
    isParkingZoneActive: true,
    isRestrictedParkingZoneActive: true,
    isRestrictedDrivingZoneActive: true,
  )) {
    on<AllGeozonesToggled>(_onAllGeozonesToggled);
    on<AllGeomarksToggled>(_onAllGeomarksToggled);
    on<ParkingZonesToggled>(_onParkingZonesToggled);
    on<RestrictedParkingZonesToggled>(_onRestrictedParkingZonesToggled);
    on<RestrictedDrivingZonesToggled>(_onRestrictedDrivingZonesToggled);
    on<ApllyButtonClick>(_onApplyClick);
    on<MapSettingsModalStarted>(_onModalStarted);
  }

  FutureOr<void> _onAllGeozonesToggled(AllGeozonesToggled event, Emitter<MapSettingsModalState> emit) {
    emit(state.copyWith(
      isAllGeozonesActive: event.value,
      isRestrictedParkingZoneActive: event.value,
      isParkingZoneActive: event.value,
      isRestrictedDrivingZoneActive: event.value,
    ));
  }

  FutureOr<void> _onParkingZonesToggled(ParkingZonesToggled event, Emitter<MapSettingsModalState> emit) {
    final newState = state.copyWith(isParkingZoneActive: event.value);
    emit(_calculateParentState(newState));
  }

  FutureOr<void> _onRestrictedParkingZonesToggled(RestrictedParkingZonesToggled event, Emitter<MapSettingsModalState> emit) {
    final newState = state.copyWith(isRestrictedParkingZoneActive: event.value);
    emit(_calculateParentState(newState));
  }

  FutureOr<void> _onRestrictedDrivingZonesToggled(RestrictedDrivingZonesToggled event, Emitter<MapSettingsModalState> emit) {
    final newState = state.copyWith(isRestrictedDrivingZoneActive: event.value);
    emit(_calculateParentState(newState));
  }

  MapSettingsModalState _calculateParentState(MapSettingsModalState currentState) {
    final bool anyChildActive = currentState.isParkingZoneActive ||
        currentState.isRestrictedParkingZoneActive ||
        currentState.isRestrictedDrivingZoneActive;

    return currentState.copyWith(isAllGeozonesActive: anyChildActive);
  }

  FutureOr<void> _onAllGeomarksToggled(AllGeomarksToggled event, Emitter<MapSettingsModalState> emit) {
    emit(state.copyWith(isGeomarksActive: event.value));
  }

  FutureOr<void> _onApplyClick(ApllyButtonClick event, Emitter<MapSettingsModalState> emit) async {
    MapSettings settings = MapSettings(
        all_placemarks: state.isAllGeomarksActive,
        all_zones: state.isAllGeozonesActive,
        parking_zones: state.isParkingZoneActive,
        restricted_parking_zones: state.isRestrictedParkingZoneActive,
        restricted_driving_zones: state.isRestrictedDrivingZoneActive);
    await saveMapSettingsUsecase(settings);
  }

  FutureOr<void> _onModalStarted(MapSettingsModalStarted event, Emitter<MapSettingsModalState> emit) async {
    final settings = await getMapSettingsUsecase();
    emit(state.copyWith(
      isGeomarksActive: settings.all_placemarks,
      isAllGeozonesActive: settings.all_zones,
      isParkingZoneActive: settings.parking_zones,
      isRestrictedParkingZoneActive: settings.restricted_parking_zones,
      isRestrictedDrivingZoneActive: settings.restricted_driving_zones,
    ));
  }
}
