import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/payment_card.dart';
import '../../domain/usecase/get_payment_cards_usecase.dart';
import '../event/payment_method_sheet_event.dart';
import '../state/payment_method_sheet_state.dart';

class PaymentMethodSheetBloc extends Bloc<PaymentMethodSheetEvent, PaymentMethodSheetState> {
  final GetPaymentCardsUsecase _getPaymentCardsUsecase;

  PaymentMethodSheetBloc(this._getPaymentCardsUsecase)
      : super(PaymentMethodSheetState(status: PaymentMethodSheetStatus.initial)) {
    on<PaymentMethodSheetStarted>(_onStarted);
  }

  Future<void> _onStarted(
    PaymentMethodSheetStarted event,
    Emitter<PaymentMethodSheetState> emit,
  ) async {
    emit(state.copyWith(status: PaymentMethodSheetStatus.loading));

    try {
      final result = await _getPaymentCardsUsecase();

      if (result is Success<List<PaymentCard>>) {
        emit(state.copyWith(
          status: PaymentMethodSheetStatus.success,
          cards: result.data ?? [],
        ));
      } else {
        emit(state.copyWith(
          status: PaymentMethodSheetStatus.failure,
          errorMessage: 'Failed to load payment cards',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PaymentMethodSheetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
