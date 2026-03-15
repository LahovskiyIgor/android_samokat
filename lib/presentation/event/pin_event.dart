abstract class PinCreateEvent {}

class PinDigitChanged extends PinCreateEvent {
  final String pin;

  PinDigitChanged(this.pin);
}

class PinSubmitted extends PinCreateEvent {
  final String pin;

  PinSubmitted(this.pin);
}
