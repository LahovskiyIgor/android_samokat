class VerifyCodeState {
  final String phoneNumber;
  final String tempToken;
  final String code;
  final int secondsLeft;
  final int attemptsLeft;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isBlocked;
  final String? error;

  VerifyCodeState({
    required this.phoneNumber,
    required this.tempToken,
    required this.code,
    required this.secondsLeft,
    required this.attemptsLeft,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isBlocked,
    this.error,
  });

  factory VerifyCodeState.initial() {
    return VerifyCodeState(
      phoneNumber: '',
      tempToken: '',
      code: '',
      secondsLeft: 60,
      attemptsLeft: 3,
      isSubmitting: false,
      isSuccess: false,
      isBlocked: false,
    );
  }

  VerifyCodeState copyWith({
    String? phoneNumber,
    String? tempToken,
    String? code,
    int? secondsLeft,
    int? attemptsLeft,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isBlocked,
    String? error,
  }) {
    return VerifyCodeState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      tempToken: tempToken ?? this.tempToken,
      code: code ?? this.code,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      attemptsLeft: attemptsLeft ?? this.attemptsLeft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isBlocked: isBlocked ?? this.isBlocked,
      error: error,
    );
  }
}