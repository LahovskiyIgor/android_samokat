import 'package:by_happy/domain/entities/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/usecase/get_profile_usecase.dart';
import '../../domain/usecase/update_profile_usecase.dart';
import '../event/edit_profile_event.dart';
import '../event/profile_event.dart';
import '../state/edit_profile_state.dart';
import '../state/profile_state.dart';

class EditProfileBloc
    extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final GetProfileUseCase getProfileUseCase;

  EditProfileBloc(this.updateProfileUseCase, this.getProfileUseCase)
      : super(EditProfileState.initial()) {

    on<EditProfileStarted>(_onStarted);

    on<EditProfileSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
      EditProfileSubmitted event,
      Emitter<EditProfileState> emit,
      ) async {
    emit(state.copyWith(isSaving: true));

    try {
      await updateProfileUseCase(event.profile);

      emit(state.copyWith(isSaving: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onStarted(
      EditProfileStarted event,
      Emitter<EditProfileState> emit,
      ) async {
    emit(state.copyWith(isSaving: true));

    print("EDIT BLOC STARTED");
    try {
      final profile = await getProfileUseCase();

      emit(state.copyWith(profile: profile, isSaving: false, isSuccess: false));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }
}
