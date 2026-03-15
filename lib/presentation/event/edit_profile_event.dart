import '../../domain/entities/user_profile.dart';

abstract class EditProfileEvent {}

class EditProfileStarted extends EditProfileEvent {}


class EditProfileSubmitted extends EditProfileEvent {
  final UserProfile profile;

  EditProfileSubmitted(this.profile);
}

