class AuthBlockException implements Exception {
  String description = "Неверный код. Вы временно заблокированы, попробуйте позже.";

  AuthBlockException();

  @override
  String toString() => description;
}
