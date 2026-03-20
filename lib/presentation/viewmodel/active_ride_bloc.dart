import 'dart:async';
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
  final FinishRideUsecase _finishRideUsecase;
  final PauseRideUsecase _pauseRideUsecase;
  final ResumeRideUsecase _resumeRideUsecase;
  final GetScooterOrderByIdUsecase _getScooterOrderByIdUsecase;
  Timer? _syncTimer;

  ActiveRideBloc(
    this._finishRideUsecase,
    this._pauseRideUsecase,
    this._resumeRideUsecase,
    this._getScooterOrderByIdUsecase,
  ) : super(const ActiveRideState()) {
    on<LoadScooterOrder>(_onLoadScooterOrder);
    on<PauseRide>(_onPauseRide);
    on<ResumeRide>(_onResumeRide);
    on<FinishRide>(_onFinishRide);
    on<SyncScooterOrder>(_onSyncScooterOrder);
  }

  @override
  Future<void> close() {
    _syncTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadScooterOrder(
    LoadScooterOrder event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.loading));

    final result = await _getScooterOrderByIdUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final order = result.data; // Здесь order уже не null, если Success реализован верно

      // Исправляем доступ к полям:
      // 1. Используем ?? для startAt, так как он nullable
      final startTime = order?.startAt ?? order?.createdAt;
      final elapsedTime = DateTime.now().difference(startTime!);
      final isPaused = order?.status.toLowerCase() == 'pause';

      emit(state.copyWith(
        status: ActiveRideStatus.success,
        order: order,
        elapsedTime: elapsedTime,
        speed: 0.0,
        distance: 0.0,
        cost: order?.totalPrice ?? 0.0,
        isPaused: isPaused,
      ));

      // Запускаем периодическую синхронизацию
      _syncTimer?.cancel();
      _syncTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        add(SyncScooterOrder(event.orderId));
      });
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось загрузить информацию о поездке',
      ));
    }
    print("CURRENT STATE $state");

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
        order: result.data,
        isPaused: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось поставить поездку на паузу',
      ));
    }
    print("CURRENT STATE $state");
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
        order: result.data,
        isPaused: false,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось возобновить поездку',
      ));
    }
    print("CURRENT STATE $state");
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
        order: result.data,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: 'Не удалось завершить поездку',
      ));
    }
  }

  Future<void> _onSyncScooterOrder(
    SyncScooterOrder event,
    Emitter<ActiveRideState> emit,
  ) async {
    final result = await _getScooterOrderByIdUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final order = result.data;
      final startTime = order?.startAt ?? order?.createdAt;
      final elapsedTime = DateTime.now().difference(startTime!);
      final isPaused = order?.status.toLowerCase() == 'pause';

      emit(state.copyWith(
        order: order,
        elapsedTime: elapsedTime,
        speed: state.speed,
        distance: state.distance,
        cost: order?.totalPrice ?? state.cost,
        isPaused: isPaused,
      ));
    }
    print("CURRENT STATE $state");

  }
}
