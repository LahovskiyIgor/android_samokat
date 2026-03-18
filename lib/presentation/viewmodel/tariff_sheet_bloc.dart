import 'dart:async';

import 'package:by_happy/domain/entities/payment_card.dart';
import 'package:by_happy/domain/usecase/get_payment_cards_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/tariff.dart';
import '../../domain/usecase/get_available_tariffs_usecase.dart';
import '../event/tariff_sheet_event.dart';
import '../state/tariff_sheet_state.dart';

class TariffSheetBloc extends Bloc<TariffSheetEvent, TariffSheetState> {
  final GetAvailableTariffsUsecase _getAvailableTariffsUsecase;
  final GetPaymentCardsUsecase _getPaymentCardsUsecase;

  TariffSheetBloc(this._getAvailableTariffsUsecase, this._getPaymentCardsUsecase)
      : super(TariffSheetState(status: TariffSheetStatus.initial)) {
    on<TariffSheetStarted>(_onStarted);
    on<PaymentCardChanged>(_onPaymentCardChanged);
  }

  Future<void> _onStarted(
    TariffSheetStarted event,
    Emitter<TariffSheetState> emit,
  ) async {
    emit(state.copyWith(status: TariffSheetStatus.loading));

    try {
      final result = await _getAvailableTariffsUsecase(event.scooterId);
      final cards_result = await _getPaymentCardsUsecase();

      if (result is Success<List<Tariff>> && cards_result is Success<List<PaymentCard>>) {
        emit(state.copyWith(
          status: TariffSheetStatus.success,
          tariffs: result.data ?? [],
          selectedCard: cards_result.data?.firstWhere((element) => element.isMain)
        ));
      } else {
        emit(state.copyWith(
          status: TariffSheetStatus.failure,
          errorMessage: 'Failed to load tariffs',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TariffSheetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  FutureOr<void> _onPaymentCardChanged(PaymentCardChanged event, Emitter<TariffSheetState> emit) {
    try {
      emit(
        state.copyWith(
          status: TariffSheetStatus.success,
          selectedCard: event.card
        )
      );
    } catch (e) {
      emit(state.copyWith(
        status: TariffSheetStatus.failure,
        errorMessage: 'Failed to change card',
      ));
    }

  }
}
