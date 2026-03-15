import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../components/custom_app_bar.dart';
import '../components/gradient_button.dart';
import '../viewmodel/profile_bloc.dart';
import 'edit_profile_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/profile_state.dart';
import '../event/profile_event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = false;
  XFile? _avatarImage;

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      context.read<ProfileBloc>().add(
        ProfilePhotoUpdated(File(pickedImage.path)),
      );

      setState(() {
        _avatarImage = pickedImage;
      });

    } catch (e) {
      print("Error picking or uploading image: $e");
    }
  }

  Future<void> _openEditProfile(UserProfile profile) async {
    context.go("/home/profile/edit"); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (state.error != null) {
                return Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final profile = state.profile!;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CustomAppBar(title: 'Профиль'),
                    const SizedBox(height: 32),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.checkboxFill,
                          backgroundImage: _avatarImage != null
                              ? FileImage(File(_avatarImage!.path))
                              : (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                              ? NetworkImage(profile.avatarUrl!)
                              : null,
                          child: _avatarImage == null
                              ? Text(
                                  profile.name,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBlue,
                                  ),
                                )
                              : null,
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            margin: const EdgeInsets.only(top: 0, right: 0),
                            child: Image.asset(
                              'assets/icons/edit.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _ProfileInfoBlock(
                      profile: profile,
                      onEditTap: () => context.go("/home/profile/edit"),
                    ),
                    const SizedBox(height: 24),
                    _SettingsBlock(
                      notificationsEnabled: notificationsEnabled,
                      onNotificationsChanged: (v) =>
                          setState(() => notificationsEnabled = v),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Widget? trailing;

  const _ProfileInfoRow({
    required this.icon,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

class _ProfileInfoBlock extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditTap;

  const _ProfileInfoBlock({required this.profile, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF141530),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Личные данные',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _ProfileInfoRow(icon: Icons.person, value: profile.name),
          _ProfileInfoRow(icon: Icons.calendar_today, value: profile.birthDate),
          _ProfileInfoRow(
            icon: Icons.phone,
            value: profile.phone,
            trailing: const Icon(Icons.lock, color: Colors.white70, size: 16),
          ),
          _ProfileInfoRow(icon: Icons.email, value: profile.email),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              onPressed: onEditTap,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide(color: AppColors.smsDigit.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Редактировать',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 16, color: AppColors.smsDigit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),

            if (value != null)
              Text(
                value!,
                style: const TextStyle(color: AppColors.white70, fontSize: 13),
              ),

            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

class _SettingsBlock extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  const _SettingsBlock({
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF141530),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Настройки',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _SettingsRow(
            title: 'Уведомления',
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: notificationsEnabled,
                onChanged: onNotificationsChanged,
                activeColor: AppColors.checkboxFill,
              ),
            ),
          ),

          _SettingsRow(
            title: 'Тема приложения',
            value: 'Системная',
            trailing: const Icon(Icons.chevron_right, color: Colors.white70),
            onTap: () {},
          ),

          _SettingsRow(
            title: 'Язык',
            value: 'Русский',
            trailing: const Icon(Icons.chevron_right, color: Colors.white70),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
