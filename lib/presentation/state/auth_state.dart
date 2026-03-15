class PhoneAuthState {
  final String phone;
  final bool isAdult;
  final bool privacyAccepted;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  PhoneAuthState({
    required this.phone,
    required this.isAdult,
    required this.privacyAccepted,
    required this.isSubmitting,
    required this.isSuccess,
    this.error,
  });

  factory PhoneAuthState.initial() {
    return PhoneAuthState(
      phone: '',
      isAdult: false,
      privacyAccepted: false,
      isSubmitting: false,
      isSuccess: false,
    );
  }

  PhoneAuthState copyWith({
    String? phone,
    bool? isAdult,
    bool? privacyAccepted,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return PhoneAuthState(
      phone: phone ?? this.phone,
      isAdult: isAdult ?? this.isAdult,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}