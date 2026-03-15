import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../components/custom_app_bar.dart';
import '../components/gradient_button.dart';
import '../event/edit_profile_event.dart';
import '../state/edit_profile_state.dart';
import '../event/profile_event.dart';
import '../viewmodel/edit_profile_bloc.dart';
import '../viewmodel/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController birthDateController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;

  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    context.read<EditProfileBloc>().add(EditProfileStarted());

    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();

    String initialDateText = '';

    if (widget.profile.birthDate.isNotEmpty) {
      try {
        _selectedBirthDate = DateFormat('dd.MM.yyyy').parse(widget.profile.birthDate);
        initialDateText = DateFormat('dd.MM.yyyy').format(_selectedBirthDate!);
      } catch (e) {
        initialDateText = widget.profile.birthDate;
        print("EXCEPTION:  $e");
      }
    }
    birthDateController = TextEditingController(text: initialDateText);
  }

  void _submit(BuildContext context) {
    final profileFromState = context.read<EditProfileBloc>().state.profile;
    if (profileFromState == null) return;

    final String birthDateForApi = _selectedBirthDate?.toIso8601String() ?? '';

    final updatedProfile = profileFromState.copyWith(
      name: nameController.text,
      birthDate: birthDateForApi.isNotEmpty ? "${birthDateForApi}Z" : '',
      email: emailController.text,
    );

    context.read<EditProfileBloc>().add(EditProfileSubmitted(updatedProfile));
    context.read<ProfileBloc>().add(ProfileUpdated());

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        birthDateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<EditProfileBloc, EditProfileState>(
              listener: (context, state) {
                final profile = state.profile;
                if (profile != null && nameController.text.isEmpty) {
                  nameController.text = profile.name;
                  phoneController.text = profile.phone;
                  emailController.text = profile.email;
                  birthDateController.text = profile.birthDate;

                }

                if (state.isSuccess) {
                  context.read<ProfileBloc>().add(ProfileUpdated());
                  context.pop();
                }
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
                }
              },
              builder: (context, state) {
                if (state.profile == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: 16),
                    CustomAppBar(title: 'Личные данные'),
                    const SizedBox(height: 32),
                    _Field(
                      'Имя',
                      nameController,
                      iconPath: 'assets/icons/edit.png',
                    ),
                    _Field(
                      'Дата рождения',
                      birthDateController,
                      iconPath: 'assets/icons/edit.png',
                      readOnly: true,
                      onTap: () => _selectDate(
                        context,
                      ),
                    ),
                    _Field(
                      'Телефон',
                      phoneController,
                      iconPath: 'assets/icons/lock.png',
                      enabled: false,
                    ),
                    _Field(
                      'E-mail',
                      emailController,
                      iconPath: 'assets/icons/edit.png',
                    ),
                    const Spacer(),
                    state.isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : GradientButton(
                            text: 'Сохранить изменения',
                            onTap: () => _submit(context),
                            width: double.infinity,
                            height: 56,
                            fontSize: 16,
                            showArrows: true,
                          ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String iconPath;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;

  const _Field(
    this.label,
    this.controller, {
    required this.iconPath,
    this.enabled = true,
    this.readOnly = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = enabled
        ? Colors.white.withOpacity(0.3)
        : Colors.white.withOpacity(0.15);
    final iconOpacity = enabled ? 0.7 : 0.3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: borderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.smsDigit, width: 1.5),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Opacity(
              opacity: iconOpacity,
              child: Image.asset(iconPath, width: 20, height: 20),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ),
    );
  }
}
