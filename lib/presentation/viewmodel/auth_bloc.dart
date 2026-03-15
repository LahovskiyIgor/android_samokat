import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/login_usecase.dart';
import '../event/auth_event.dart';
import '../state/auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final LoginUseCase _loginUseCase;

  PhoneAuthBloc(this._loginUseCase) : super(PhoneAuthState.initial()) {
    on<PhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });

    on<IsAdultChanged>((event, emit) {
      emit(state.copyWith(isAdult: event.isAdult));
    });

    on<PrivacyAcceptedChanged>((event, emit) {
      emit(state.copyWith(privacyAccepted: event.accepted));
    });

    on<SubmitPhonePressed>(_onSubmitPhonePressed);
  }

  Future<void> _onSubmitPhonePressed(
      SubmitPhonePressed event,
      Emitter<PhoneAuthState> emit,
      ) async {
    if (state.isSubmitting) return;

    final phone = state.phone;
    final isAdult = state.isAdult;
    final privacyAccepted = state.privacyAccepted;

    if (phone.isEmpty || !isAdult || !privacyAccepted) {
      emit(state.copyWith(error: "Пожалуйста, заполните все поля."));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));

    //готовы отправить данные, вызываем юзкейс
    try {
      final tempToken = await _loginUseCase.execute('+375$phone');
      print("TOKEN ON PRESENTATION LAYER: $tempToken");
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}