abstract class VerifyCodeEvent {}

class VerifyCodeStarted extends VerifyCodeEvent {
  final String phoneNumber;
  final String tempToken;

  VerifyCodeStarted({required this.phoneNumber, required this.tempToken});
}

class CodeChanged extends VerifyCodeEvent {
  final String code;

  CodeChanged(this.code);
}

class ResendCodePressed extends VerifyCodeEvent {}

class VerifyCodeSubmitted extends VerifyCodeEvent {}