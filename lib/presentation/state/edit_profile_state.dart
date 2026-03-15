import '../../domain/entities/user_profile.dart';

class EditProfileState {
  final bool isSaving;
  final bool isSuccess;
  final bool isLoading;
  final UserProfile? profile;
  final String? error;

  const EditProfileState({
    required this.isSaving,
    required this.isSuccess,
    required this.isLoading,
    this.profile,
    this.error,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      isSaving: false,
      isSuccess: false,
      isLoading: false,
    );
  }

  EditProfileState copyWith({
    bool? isSaving,
    bool? isSuccess,
    bool? isLoading,
    UserProfile? profile,
    String? error,
  }) {
    return EditProfileState(
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

