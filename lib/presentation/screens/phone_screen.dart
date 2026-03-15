import 'package:by_happy/presentation/event/spalsh_event.dart';
import 'package:by_happy/presentation/state/splash_state.dart';
import 'package:by_happy/presentation/viewmodel/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_colors.dart';
import '../components/app_checkbox.dart';
import '../components/gradient_button.dart';
import '../event/auth_event.dart';
import '../state/auth_state.dart';
import '../viewmodel/auth_bloc.dart';
import 'phone_login_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isAdult = false;
  bool _acceptedPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.go("/verify?phone=+375${state.phone}");
          context.read<SplashBloc>().add(AuthStarted());
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.phoneScreenBg,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  Image.asset(
                    'assets/wave.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          const Text(
                            'Введите номер телефона',
                            style: TextStyle(
                              color: AppColors.whiteText,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 40),

                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: AppColors.whiteText),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.disabledButtonColor,
                              prefixText: '+375 ',
                              prefixStyle: const TextStyle(
                                color: AppColors.whiteText,
                                fontSize: 16,
                              ),
                              hintText: 'Номер телефона',
                              hintStyle: const TextStyle(color: AppColors.hint),
                              suffixIcon: _phoneController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.whiteText),
                                onPressed: () {
                                  _phoneController.clear();
                                  context.read<PhoneAuthBloc>().add(PhoneChanged(""));
                                },
                              )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              context.read<PhoneAuthBloc>().add(PhoneChanged(value));
                            },
                          ),

                          const SizedBox(height: 24),

                          GestureDetector(
                            onTap: () {
                              final newValue = !_isAdult;
                              setState(() => _isAdult = newValue);
                              context.read<PhoneAuthBloc>().add(IsAdultChanged(newValue));
                            },
                            child: Row(
                              children: [
                                AppCheckbox(
                                  value: _isAdult,
                                  onChanged: (_) {},
                                  isError: state.error != null && !_isAdult,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                      'Подтверждаю, что мне исполнилось 18 лет и я приняла ',
                                      style: const TextStyle(
                                          color: AppColors.white70, fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text:
                                          'Условия использования сервиса',
                                          style: const TextStyle(
                                            color: Colors.blueAccent,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          GestureDetector(
                            onTap: () {
                              final newValue = !_acceptedPrivacy;
                              setState(() => _acceptedPrivacy = newValue);
                              context.read<PhoneAuthBloc>().add(PrivacyAcceptedChanged(newValue));
                            },
                            child: Row(
                              children: [
                                AppCheckbox(
                                  value: _acceptedPrivacy,
                                  onChanged: (_) {},
                                  isError: state.error != null && !_acceptedPrivacy,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Подтверждаю, что я ознакомился с ',
                                      style: TextStyle(
                                          color: AppColors.white70, fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text:
                                          'Политикой обработки персональных данных',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 47),

                          GradientButton(
                            text: "Получить код",
                            enabled: state.phone.isNotEmpty && _isAdult && _acceptedPrivacy && !state.isSubmitting,
                            onTap: state.isSubmitting
                                ? null
                                : () {
                              context.read<PhoneAuthBloc>().add(SubmitPhonePressed());
                            },
                            showArrows: true,
                            height: 50,
                            width: 340,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}