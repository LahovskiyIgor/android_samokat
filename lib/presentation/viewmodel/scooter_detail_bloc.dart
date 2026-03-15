import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/scooter.dart';
import '../../domain/usecase/get_scooter_usecase.dart';
import '../event/scooter_detail_event.dart';
import '../state/scooter_detail_state.dart';

class ScooterDetailBloc extends Bloc<ScooterDetailEvent, ScooterDetailState> {
  final GetScooterUsecase _getScooterUsecase;

  ScooterDetailBloc(this._getScooterUsecase) : super(const ScooterDetailState()) {
    on<LoadScooterDetails>(_onLoadScooterDetails);
  }

  Future<void> _onLoadScooterDetails(
      LoadScooterDetails event,
      Emitter<ScooterDetailState> emit,
      ) async {
    emit(state.copyWith(status: ScooterStatus.loading));

    final result = await _getScooterUsecase(event.scooterId);

    if (result is Success<Scooter?>) {
      print("SCOOTER: ${result.data}");
      emit(state.copyWith(
        status: ScooterStatus.success,
        scooter: result.data,
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: ScooterStatus.failure,
        errorMessage: "Не удалось загрузить данные",
      ));
    }
  }
}
