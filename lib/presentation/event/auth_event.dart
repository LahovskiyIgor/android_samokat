abstract class PhoneAuthEvent {}

class PhoneAuthStarted extends PhoneAuthEvent {}

class PhoneChanged extends PhoneAuthEvent {
  final String phone;

  PhoneChanged(this.phone);
}

class IsAdultChanged extends PhoneAuthEvent {
  final bool isAdult;

  IsAdultChanged(this.isAdult);
}

class PrivacyAcceptedChanged extends PhoneAuthEvent {
  final bool accepted;

  PrivacyAcceptedChanged(this.accepted);
}

class SubmitPhonePressed extends PhoneAuthEvent {}