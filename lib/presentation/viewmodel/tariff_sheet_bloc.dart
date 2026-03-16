import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/tariff.dart';
import '../../domain/usecase/get_available_tariffs_usecase.dart';
import '../event/tariff_sheet_event.dart';
import '../state/tariff_sheet_state.dart';

class TariffSheetBloc extends Bloc<TariffSheetEvent, TariffSheetState> {
  final GetAvailableTariffsUsecase _getAvailableTariffsUsecase;

  TariffSheetBloc(this._getAvailableTariffsUsecase)
      : super(TariffSheetState(status: TariffSheetStatus.initial)) {
    on<TariffSheetStarted>(_onStarted);
  }

  Future<void> _onStarted(
    TariffSheetStarted event,
    Emitter<TariffSheetState> emit,
  ) async {
    emit(state.copyWith(status: TariffSheetStatus.loading));

    try {
      final result = await _getAvailableTariffsUsecase(event.scooterId);

      if (result is Success<List<Tariff>>) {
        emit(state.copyWith(
          status: TariffSheetStatus.success,
          tariffs: result.data ?? [],
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
}
