import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/result.dart';
import '../../../domain/entities/scooter_order.dart';
import '../../../domain/usecase/finish_ride_usecase.dart';
import '../../../domain/usecase/pause_ride_usecase.dart';
import '../event/active_ride_event.dart';
import '../state/active_ride_state.dart';

class ActiveRideBloc extends Bloc<ActiveRideEvent, ActiveRideState> {
  final PauseRideUsecase _pauseRideUsecase;
  final FinishRideUsecase _finishRideUsecase;

  ActiveRideBloc(
    this._pauseRideUsecase,
    this._finishRideUsecase,
  ) : super(const ActiveRideState()) {
    on<PauseRide>(_onPauseRide);
    on<FinishRide>(_onFinishRide);
  }

  Future<void> _onPauseRide(
    PauseRide event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.loading));

    final result = await _pauseRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        ridePaused: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: result.errorMessage ?? 'Не удалось поставить на паузу',
      ));
    }
  }

  Future<void> _onFinishRide(
    FinishRide event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.loading));

    final result = await _finishRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        rideFinished: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: result.errorMessage ?? 'Не удалось завершить поездку',
      ));
    }
  }
}
