import 'dart:async';

import 'package:by_happy/core/failures.dart';
import 'package:by_happy/core/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/verify_code_usecase.dart';
import '../event/verify_code_event.dart';
import '../state/verify_code_state.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  final VerifyCodeUseCase _verifyCodeUseCase;
  Timer? _timer;

  VerifyCodeBloc(this._verifyCodeUseCase)
      : super(VerifyCodeState.initial()) {
    on<VerifyCodeStarted>((event, emit) {
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        tempToken: event.tempToken,
        secondsLeft: 60,
      ));
      _startTimer();
    });

    on<CodeChanged>((event, emit) {
      emit(state.copyWith(code: event.code));
    });

    on<ResendCodePressed>((event, emit) {
      if (state.secondsLeft == 0) {
        emit(state.copyWith(secondsLeft: 60));
        _startTimer();
      }
    });

    on<VerifyCodeSubmitted>(_onVerifyCodeSubmitted);
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsLeft <= 1) {
        timer.cancel();
        emit(state.copyWith(secondsLeft: 0));
      } else {
        emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
      }
    });
  }

  Future<void> _onVerifyCodeSubmitted(VerifyCodeSubmitted event,
      Emitter<VerifyCodeState> emit,) async {
    if (state.isSubmitting || state.code.length != 6) return;

    emit(state.copyWith(isSubmitting: true, error: null));

    final result = await _verifyCodeUseCase.execute(state.code, state.tempToken);

    final newState = switch (result) {
      Success() => state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      ),
      Failure(failure: final f) => switch (f) {
        AuthFailure(attemptsLeft: final count) => state.copyWith(
          isSubmitting: false,
          attemptsLeft: count,
          error: 'Неверный код. Осталось попыток: $count',
        ),
        AuthBlockFailure() => state.copyWith(
          isSubmitting: false,
          isBlocked: true,
          error: 'Вы заблокированы за слишком частые попытки',
        ),
        _ => state.copyWith(
          isSubmitting: false,
          error: 'Произошла ошибка. Попробуйте позже',
        ),
      },
    };

    emit(newState);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
