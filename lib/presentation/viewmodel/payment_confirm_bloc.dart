import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/result.dart';
import '../../../domain/entities/scooter_order.dart';
import '../../../domain/usecase/pay_ride_usecase.dart';
import '../event/payment_confirm_event.dart';
import '../state/payment_confirm_state.dart';

class PaymentConfirmBloc extends Bloc<PaymentConfirmEvent, PaymentConfirmState> {
  final PayRideUsecase _payRideUsecase;

  PaymentConfirmBloc(this._payRideUsecase) : super(const PaymentConfirmState()) {
    on<PayRide>(_onPayRide);
  }

  Future<void> _onPayRide(
    PayRide event,
    Emitter<PaymentConfirmState> emit,
  ) async {
    emit(state.copyWith(status: PaymentConfirmStatus.loading));

    // TODO: В будущем использовать event.photoIds вместо захардкоженного значения
    final photoIds = event.photoIds.isEmpty ? [1] : event.photoIds;

    final result = await _payRideUsecase(event.orderId);

    if (result is Success<ScooterOrder>) {
      emit(state.copyWith(
        status: PaymentConfirmStatus.success,
        paymentCompleted: true,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: PaymentConfirmStatus.failure,
        errorMessage: 'Не удалось оплатить поездку',
      ));
    }
  }
}
