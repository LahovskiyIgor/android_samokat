import 'package:by_happy/domain/usecase/upload_profile_photo_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_profile_usecase.dart';
import '../event/profile_event.dart';
import '../state/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UploadProfilePhotoUsecase uploadProfilePhotoUsecase;


  ProfileBloc(this.getProfileUseCase,
      this.uploadProfilePhotoUsecase)
      : super(ProfileState.initial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUpdated>(_onUpdated);
    on<ProfilePhotoUpdated>(_onPhotoUploaded);
  }

  Future<void> _onStarted(
      ProfileStarted event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    print("_onStarted method was start");
    try {
      final profile = await getProfileUseCase();
      print(profile.name);

      emit(state.copyWith(isLoading: false, profile: profile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "STARTED: ${e.toString()}"));
    }
  }

  Future<void> _onUpdated(
      ProfileUpdated event,
      Emitter<ProfileState> emit,
      ) async {
    final profile = await getProfileUseCase();
    emit(state.copyWith(profile: profile));
  }

  Future<void> _onPhotoUploaded(
      ProfilePhotoUpdated event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await uploadProfilePhotoUsecase(event.imageFile);

      add(ProfileStarted());

    } catch (e) {
      // 4. В случае ошибки, выключаем загрузку и показываем ошибку
      emit(state.copyWith(isLoading: false, error: "UPDATE: ${e.toString()}"));
    }
  }
}
