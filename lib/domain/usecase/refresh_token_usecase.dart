import '../entities/user_auth_data.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  Future<UserAuthData> execute() async {
    return await _repository.refreshToken();
  }
}