class UnauthorizedException implements Exception {

  @override
  String toString() => "Ошибка авторизации. Пользователь не авторизован";
}
