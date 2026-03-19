import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/result.dart';
import '../../../domain/entities/scooter_order.dart';
import '../../../domain/usecase/finish_ride_usecase.dart';
import '../../../domain/usecase/pause_ride_usecase.dart';
import '../../../domain/usecase/resume_ride_usecase.dart';
import '../../../domain/usecase/get_scooter_order_by_id_usecase.dart';
import '../event/active_ride_event.dart';
import '../state/active_ride_state.dart';

class ActiveRideBloc extends Bloc<ActiveRideEvent, ActiveRideState> {
  final PauseRideUsecase _pauseRideUsecase;
  final ResumeRideUsecase _resumeRideUsecase;
  final FinishRideUsecase _finishRideUsecase;
  final GetScooterOrderByIdUsecase _getScooterOrderByIdUsecase;

  ActiveRideBloc(
    this._pauseRideUsecase,
    this._resumeRideUsecase,
    this._finishRideUsecase,
    this._getScooterOrderByIdUsecase,
  ) : super(const ActiveRideState()) {
    on<LoadScooterOrder>(_onLoadScooterOrder);
    on<PauseRide>(_onPauseRide);
    on<ResumeRide>(_onResumeRide);
    on<FinishRide>(_onFinishRide);
  }

  Future<void> _onLoadScooterOrder(
    LoadScooterOrder event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.loading));

    final result = await _getScooterOrderByIdUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final order = result.data;
      final isPaused = order.status.toLowerCase() == 'paused';
      
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        scooterOrder: order,
        isPaused: isPaused,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось загрузить данные поездки',
      ));
    }
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
        scooterOrder: result.data,
        isPaused: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось поставить на паузу',
      ));
    }
  }

  Future<void> _onResumeRide(
    ResumeRide event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.loading));

    final result = await _resumeRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        scooterOrder: result.data,
        isPaused: false,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось возобновить поездку',
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
        scooterOrder: result.data,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось завершить поездку',
      ));
    }
  }
}
