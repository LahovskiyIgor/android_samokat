sealed class EntityFailure {
  final String? message;
  EntityFailure([this.message]);
}

class AuthFailure extends EntityFailure {
  final int attemptsLeft;
  AuthFailure(this.attemptsLeft);
}

class AuthBlockFailure extends EntityFailure {}

class UnknownFailure extends EntityFailure {}