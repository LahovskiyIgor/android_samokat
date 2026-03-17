import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/add_payment_card_usecase.dart';
import '../event/add_card_event.dart';
import '../state/add_card_state.dart';

// 🔹 Импорты для Result и Failure
import '../../core/result.dart';
import '../../core/failures.dart';

class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  final AddPaymentCardUsecase addPaymentCardUsecase;

  AddCardBloc(this.addPaymentCardUsecase) : super(const AddCardState()) {
    on<CardNumberChanged>(_onCardNumberChanged);
    on<ExpiryDateChanged>(_onExpiryDateChanged);
    on<CvvChanged>(_onCvvChanged);
    on<CardHolderChanged>(_onCardHolderChanged);
    on<AddCardSubmitted>(_onAddCardSubmitted);
  }

  void _onCardNumberChanged(CardNumberChanged event, Emitter<AddCardState> emit) {
    final formatted = _formatCardNumber(event.cardNumber);
    emit(state.copyWith(cardNumber: formatted));
  }

  void _onExpiryDateChanged(ExpiryDateChanged event, Emitter<AddCardState> emit) {
    final formatted = _formatExpiryDate(event.expiryDate);
    emit(state.copyWith(expiryDate: formatted));
  }

  void _onCvvChanged(CvvChanged event, Emitter<AddCardState> emit) {
    final formatted = event.cvv.replaceAll(RegExp(r'\D'), '').substring(0, 3);
    emit(state.copyWith(cvv: formatted));
  }

  void _onCardHolderChanged(CardHolderChanged event, Emitter<AddCardState> emit) {
    // Разрешаем только буквы и пробелы, убираем лишние пробелы
    final formatted = event.cardHolder.replaceAll(RegExp(r'[^a-zA-Zа-яА-ЯёЁ\s]'), '').trim();
    emit(state.copyWith(cardHolder: formatted));
  }

  Future<void> _onAddCardSubmitted(AddCardSubmitted event, Emitter<AddCardState> emit) async {
    emit(state.copyWith(status: AddCardStatus.loading));

    final expiryParts = event.expiryDate.split('/');
    if (expiryParts.length != 2) {
      emit(state.copyWith(
        status: AddCardStatus.failure,
        errorMessage: 'Неверный формат даты',
      ));
      return;
    }

    final month = int.tryParse(expiryParts[0]);
    final year = int.tryParse(expiryParts[1]);

    if (month == null || year == null) {
      emit(state.copyWith(
        status: AddCardStatus.failure,
        errorMessage: 'Неверный формат даты',
      ));
      return;
    }

    final result = await addPaymentCardUsecase(
      cardNumber: event.cardNumber,
      cardHolder: event.cardHolder,
      expiryMonth: expiryParts[0],
      expiryYear: expiryParts[1],
      cvv: event.cvv,
    );

    // ✅ Теперь работает — импорты добавлены
    if (result is Success) {
      emit(state.copyWith(status: AddCardStatus.success));
    } else if (result is Failure) {
      final failure = result.failure;

      String errorMessage = 'Ошибка добавления карты';

      if (failure is AuthFailure) {
        errorMessage = 'Неверные данные карты';
      } else if (failure is AuthBlockFailure) {
        errorMessage = 'Доступ заблокирован';
      } else if (failure is UnknownFailure) {
        errorMessage = failure.message ?? 'Неизвестная ошибка';
      }

      emit(state.copyWith(
        status: AddCardStatus.failure,
        errorMessage: errorMessage,
      ));
    }
  }

  String _formatCardNumber(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    final limited = cleaned.substring(0, cleaned.length > 16 ? 16 : cleaned.length);

    String formatted = '';
    for (int i = 0; i < limited.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += limited[i];
    }

    return formatted;
  }

  String _formatExpiryDate(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.isEmpty) return '';

    if (cleaned.length <= 2) {
      return cleaned;
    }

    final month = cleaned.substring(0, 2);
    final year = cleaned.substring(2, cleaned.length > 4 ? 4 : cleaned.length);

    return '$month/$year';
  }
}