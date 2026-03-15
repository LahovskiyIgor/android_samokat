import 'dart:async';

import 'package:by_happy/domain/entities/map_settings.dart';
import 'package:by_happy/domain/usecase/get_available_zones_usecase.dart';
import 'package:by_happy/domain/usecase/get_map_settings_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/scooter.dart';
import '../../domain/entities/zone.dart';
import '../../domain/usecase/get_available_scooters_usecase.dart';
import '../event/map_event.dart';
import '../state/map_state.dart';

class MapBloc extends Bloc<ScooterEvent, ScooterState> {
  final GetAvailableScootersUsecase getScootersUsecase;
  final GetAvailableZonesUsecase getAvailableZonesUsecase;
  final GetMapSettingsUsecase getMapSettingsUsecase;

  MapBloc( this.getAvailableZonesUsecase, this.getScootersUsecase, this.getMapSettingsUsecase) : super(
      ScooterState(
        isGeomarksShowed: true,
  )) {
    on<FetchScooters>(_onFetchScooters);
    on<UpdateMap>(_onUpdateMap);
  }

  Future<void> _onFetchScooters(FetchScooters event, Emitter<ScooterState> emit) async {
    emit(state.copyWith(status: ScooterStatus.loading));

      final results = await Future.wait([
        getScootersUsecase(event.area, 0, 100),
        getAvailableZonesUsecase(event.area, 0, 100),
        getMapSettingsUsecase(),
      ]);

      final scooters = results[0] as List<Scooter>;
      final zones = results[1] as List<Zone>;
      final settings = results[2] as MapSettings;

      zones.forEach(print);

      List<Zone> filteredZones = [];

      if (settings.all_zones){
        if (settings.parking_zones) {
          filteredZones.addAll(zones.where((el) => el.type == "Finish" ));
        }
        if (settings.restricted_parking_zones) {
          filteredZones.addAll(zones.where((el) => el.type == "Drive" ));
        }
        if (settings.restricted_driving_zones) {
          filteredZones.addAll(zones.where((el) => el.type == "NotDrive" ));
        }
      }
    // filteredZones.forEach(print);


      emit(state.copyWith(
        status: ScooterStatus.success,
        scooters: scooters,
        zones: filteredZones,
        area: event.area,
        isGeomarksShowed: settings.all_placemarks,
      ));
  }

  Future<void> _onUpdateMap(UpdateMap event, Emitter<ScooterState> emit) async {
    emit(state.copyWith(status: ScooterStatus.loading));

    try {
      final results = await Future.wait([
        getScootersUsecase(state.area, 0, 100),
        getAvailableZonesUsecase(state.area, 0, 100),
        getMapSettingsUsecase(),
      ]);

      final scooters = results[0] as List<Scooter>;
      final zones = results[1] as List<Zone>;
      final settings = results[2] as MapSettings;

      List<Zone> filtered_zones = [];

      if (settings.all_zones){
        if (settings.parking_zones) {
          filtered_zones.addAll(zones.where((el) => el.type == "Finish" ));
        }
        if (settings.restricted_parking_zones) {
          filtered_zones.addAll(zones.where((el) => el.type == "Drive" ));
        }
        if (settings.restricted_driving_zones) {
          filtered_zones.addAll(zones.where((el) => el.type == "NotDrive" ));
        }
      }

      emit(state.copyWith(
        status: ScooterStatus.success,
        scooters: scooters,
        zones: filtered_zones,
        isGeomarksShowed: settings.all_placemarks,
      ));
    } catch (e) {
      print("UPDATE ERROR: $e");
      emit(state.copyWith(
        status: ScooterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
