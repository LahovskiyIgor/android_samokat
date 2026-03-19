import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/result.dart';
import '../../../domain/entities/scooter_order.dart';
import '../../../domain/usecase/cancel_ride_usecase.dart';
import '../../../domain/usecase/start_ride_usecase.dart';
import '../event/reserved_ride_event.dart';
import '../state/reserved_ride_state.dart';

class ReservedRideBloc extends Bloc<ReservedRideEvent, ReservedRideState> {
  final StartRideUsecase _startRideUsecase;
  final CancelRideUsecase _cancelRideUsecase;

  ReservedRideBloc(
    this._startRideUsecase,
    this._cancelRideUsecase,
  ) : super(const ReservedRideState()) {
    on<StartRide>(_onStartRide);
    on<CancelRide>(_onCancelRide);
  }

  Future<void> _onStartRide(
    StartRide event,
    Emitter<ReservedRideState> emit,
  ) async {
    emit(state.copyWith(status: ReservedRideStatus.loading));

    final result = await _startRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      emit(state.copyWith(
        status: ReservedRideStatus.success,
        rideStarted: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ReservedRideStatus.failure,
        errorMessage: 'Не удалось начать поездку',
      ));
    }
  }

  Future<void> _onCancelRide(
    CancelRide event,
    Emitter<ReservedRideState> emit,
  ) async {
    emit(state.copyWith(status: ReservedRideStatus.loading));

    final result = await _cancelRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      emit(state.copyWith(
        status: ReservedRideStatus.success,
        rideCancelled: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ReservedRideStatus.failure,
        errorMessage: 'Не удалось отменить бронирование',
      ));
    }
  }
}
