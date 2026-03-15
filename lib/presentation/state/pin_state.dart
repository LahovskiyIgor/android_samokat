class PinCreateState {
  final String pin;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const PinCreateState({
    required this.pin,
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  factory PinCreateState.initial() {
    return const PinCreateState(
      pin: '',
      isLoading: false,
      isSuccess: false,
    );
  }

  PinCreateState copyWith({
    String? pin,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return PinCreateState(
      pin: pin ?? this.pin,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}
