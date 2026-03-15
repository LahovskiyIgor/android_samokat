import 'dart:io';

import '../../domain/entities/user_profile.dart';

abstract class ProfileEvent {}

class ProfileStarted extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {}

class ProfilePhotoUpdated extends ProfileEvent{
  final File imageFile;

  ProfilePhotoUpdated(this.imageFile);
}
