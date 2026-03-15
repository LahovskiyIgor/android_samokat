class AuthException implements Exception {
  int attemptsLeft;
  String? description;

  AuthException(this.description, this.attemptsLeft);

  @override
  String toString() => description ?? "Ошибка авторизации";
}
