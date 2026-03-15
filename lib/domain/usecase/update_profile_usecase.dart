import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final UserProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(UserProfile profile) {
    return repository.updateProfile(profile);
  }
}
