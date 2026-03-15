import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final UserProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserProfile> call() {
    return repository.getProfile();
  }
}

