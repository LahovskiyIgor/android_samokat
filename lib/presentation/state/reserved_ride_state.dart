enum ReservedRideStatus { initial, loading, success, failure }

class ReservedRideState {
  final ReservedRideStatus status;
  final String? errorMessage;
  final bool rideStarted;
  final bool rideCancelled;

  const ReservedRideState({
    this.status = ReservedRideStatus.initial,
    this.errorMessage,
    this.rideStarted = false,
    this.rideCancelled = false,
  });

  ReservedRideState copyWith({
    ReservedRideStatus? status,
    String? errorMessage,
    bool? rideStarted,
    bool? rideCancelled,
  }) {
    return ReservedRideState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rideStarted: rideStarted ?? this.rideStarted,
      rideCancelled: rideCancelled ?? this.rideCancelled,
    );
  }
}
