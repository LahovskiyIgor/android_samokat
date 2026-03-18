import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/scooter_order.dart';
import '../../domain/usecase/get_client_orders_usecase.dart';
import '../event/current_rides_event.dart';
import '../state/current_rides_state.dart';

class CurrentRidesBloc extends Bloc<CurrentRidesEvent, CurrentRidesState> {
  final GetClientOrdersUsecase _getClientOrdersUsecase;

  CurrentRidesBloc(this._getClientOrdersUsecase) : super(const CurrentRidesState()) {
    on<LoadClientOrders>(_onLoadClientOrders);
  }

  Future<void> _onLoadClientOrders(
    LoadClientOrders event,
    Emitter<CurrentRidesState> emit,
  ) async {
    emit(state.copyWith(status: CurrentRidesStatus.loading));

    final result = await _getClientOrdersUsecase(event.clientId);

    if (result is Success<List<ScooterOrder>>) {
      emit(state.copyWith(
        status: CurrentRidesStatus.success,
        orders: result.data ?? [],
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: CurrentRidesStatus.failure,
        errorMessage: "Не удалось загрузить заказы",
      ));
    }
  }
}
