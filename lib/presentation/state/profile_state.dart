import '../../domain/entities/user_profile.dart';

class ProfileState {
  final bool isLoading;
  final UserProfile? profile;
  final String? error;

  const ProfileState({
    required this.isLoading,
    this.profile,
    this.error,
  });

  factory ProfileState.initial() {
    return const ProfileState(isLoading: true);
  }

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}
