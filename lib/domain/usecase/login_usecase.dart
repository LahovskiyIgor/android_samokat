import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<String> execute(String phone) async {
    return await _repository.login(phone);
  }
}