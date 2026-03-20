import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/scooter_order.dart';
import '../../domain/usecase/finish_ride_usecase.dart';
import '../../domain/usecase/pause_ride_usecase.dart';
import '../../domain/usecase/resume_ride_usecase.dart';
import '../../domain/usecase/get_scooter_order_by_id_usecase.dart';
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
      final order = result.data!;
      final elapsedTime = _calculateElapsedTime(order);

      emit(state.copyWith(
        status: ActiveRideStatus.success,
        order: order,
        elapsedTime: elapsedTime,
        cost: order.totalPrice ?? 0.0,
      ));

      // Запускаем периодическую синхронизацию
      _syncTimer?.cancel();
      _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        add(SyncScooterOrder(event.orderId));
      });
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: "Не удалось загрузить информацию о поездке",
      ));
    }
  }

  Future<void> _onPauseRide(
    PauseRide event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.actionInProgress));

    final result = await _pauseRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final updatedOrder = result.data!;
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        order: updatedOrder,
      ));
      
      // Обновляем данные после паузы
      add(SyncScooterOrder(event.orderId));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: "Не удалось поставить на паузу",
      ));
    }
  }

  Future<void> _onResumeRide(
    ResumeRide event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.actionInProgress));

    final result = await _resumeRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final updatedOrder = result.data!;
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        order: updatedOrder,
      ));

      // Обновляем данные после возобновления
      add(SyncScooterOrder(event.orderId));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: "Не удалось возобновить поездку",
      ));
    }
  }

  Future<void> _onFinishRide(
    FinishRide event,
    Emitter<ActiveRideState> emit,
  ) async {
    emit(state.copyWith(status: ActiveRideStatus.actionInProgress));

    final result = await _finishRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final updatedOrder = result.data!;
      emit(state.copyWith(
        status: ActiveRideStatus.success,
        order: updatedOrder,
      ));

      // Останавливаем синхронизацию после завершения
      _syncTimer?.cancel();
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ActiveRideStatus.failure,
        errorMessage: "Не удалось завершить поездку",
      ));
    }
  }

  Future<void> _onSyncScooterOrder(
    SyncScooterOrder event,
    Emitter<ActiveRideState> emit,
  ) async {
    // Не обновляем статус на loading, чтобы не прерывать текущее состояние
    final result = await _getScooterOrderByIdUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      final order = result.data!;
      final elapsedTime = _calculateElapsedTime(order);

      emit(state.copyWith(
        order: order,
        elapsedTime: elapsedTime,
        cost: order.totalPrice ?? state.cost,
        speed: 0.0, // TODO: получить реальную скорость из данных заказа
        distance: 0.0, // TODO: получить реальное расстояние из данных заказа
      ));
    }
    // В случае ошибки просто игнорируем, чтобы не прерывать отображение
  }

  Duration _calculateElapsedTime(ScooterOrder order) {
    if (order.startAt == null) {
      return Duration.zero;
    }

    final now = DateTime.now();
    final startTime = order.startAt!;

    // Если поездка завершена, считаем до finishAt
    if (order.finishAt != null) {
      return order.finishAt!.difference(startTime);
    }

    // Иначе считаем до текущего времени
    return now.difference(startTime);
  }
}
