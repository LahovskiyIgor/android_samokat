import 'package:by_happy/domain/usecase/get_pedestrian_routes_usecase.dart';
import 'package:by_happy/domain/usecase/get_scooter_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../core/result.dart';
import '../../domain/entities/scooter.dart';
import '../../domain/usecase/get_address_by_point_usecase.dart';
import '../event/scooter_detail_event.dart';
import '../event/scooter_detail_modal_event.dart';
import '../state/map_state.dart';
import '../state/scooter_detail_modal_state.dart';

class ScooterDetailModalBloc
    extends Bloc<ScooterDetailModalEvent, ScooterDetailModalState> {
  final GetAddressByPointUsecase _getAddressUsecase;
  final GetPedestrianRoutesUsecase _getPedestrianRoutesUsecase;
  final GetScooterUsecase _getScooterUsecase;
  final Map<int, String> _addressCache = {};
  final List<Scooter> fetch_scooters = [];
  double? distance = 0.0;

  ScooterDetailModalBloc(
    this._getAddressUsecase,
    this._getScooterUsecase,
    this._getPedestrianRoutesUsecase,
  ) : super(
        ScooterDetailModalState(
          status: ScooterDetailModalStatus.initial,
        ),
      ) {
    on<ScooterDetailModalStarted>(_onStarted);
  }

  Future<void> _onStarted(
      ScooterDetailModalStarted event,
      Emitter<ScooterDetailModalState> emit,
      ) async {
    emit(state.copyWith(status: ScooterDetailModalStatus.loading));

    final List<Scooter> updatedScooters = [];
    String? firstAddress;

    try {
      for (var scooter in event.scooters) {
        final result = await _getScooterUsecase(scooter.id);

        String? currentAddress = _addressCache[scooter.id];
        if (currentAddress == null) {
          currentAddress = await _getAddressUsecase(scooter.latitude, scooter.longitude);
          _addressCache[scooter.id] = currentAddress;
        }

        firstAddress ??= currentAddress;

        final routes = await _getPedestrianRoutesUsecase(
          Point(latitude: event.userLatitude, longitude: event.userLongitude),
          Point(latitude: scooter.latitude, longitude: scooter.longitude),
        );

        final distance = routes?.firstOrNull?.metadata.weight.walkingDistance.value;
        final time = routes?.firstOrNull?.metadata.weight.time.value;

        if (result is Success<Scooter>) {
          final data = result.data!;
          data.distance = distance;
          data.timeToTravel = time;
          updatedScooters.add(data);
        } else {
          updatedScooters.add(scooter);
        }
      }

      emit(
        state.copyWith(
          status: ScooterDetailModalStatus.success,
          scooters: updatedScooters,
          address: firstAddress ?? "Unknown address",
          distance: updatedScooters.firstOrNull?.distance,
        ),
      );
    } catch (e) {
      print('Error in Bloc: $e');
      emit(state.copyWith(
        status: ScooterDetailModalStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

}
