import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/create_pin_usecase.dart';
import '../event/pin_event.dart';
import '../state/pin_state.dart';

class PinCreateBloc extends Bloc<PinCreateEvent, PinCreateState> {
  final CreatePinUseCase createPinUseCase;

  PinCreateBloc(this.createPinUseCase)
      : super(PinCreateState.initial()) {
    on<PinDigitChanged>(_onPinChanged);
    on<PinSubmitted>(_onPinSubmitted);
  }

  void _onPinChanged(
      PinDigitChanged event,
      Emitter<PinCreateState> emit,
      ) {
    emit(state.copyWith(pin: event.pin));
  }

  Future<void> _onPinSubmitted(
      PinSubmitted event,
      Emitter<PinCreateState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await createPinUseCase(event.pin);

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }
}
