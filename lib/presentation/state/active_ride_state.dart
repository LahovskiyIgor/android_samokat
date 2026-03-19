enum ActiveRideStatus { initial, loading, success, failure }

class ActiveRideState {
  final ActiveRideStatus status;
  final String? errorMessage;
  final bool ridePaused;
  final bool rideFinished;

  const ActiveRideState({
    this.status = ActiveRideStatus.initial,
    this.errorMessage,
    this.ridePaused = false,
    this.rideFinished = false,
  });

  ActiveRideState copyWith({
    ActiveRideStatus? status,
    String? errorMessage,
    bool? ridePaused,
    bool? rideFinished,
  }) {
    return ActiveRideState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      ridePaused: ridePaused ?? this.ridePaused,
      rideFinished: rideFinished ?? this.rideFinished,
    );
  }
}
