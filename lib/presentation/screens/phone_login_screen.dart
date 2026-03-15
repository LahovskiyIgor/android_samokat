import 'package:by_happy/presentation/event/spalsh_event.dart';
import 'package:by_happy/presentation/viewmodel/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_colors.dart';
import '../components/code_dots.dart';
import '../components/gradient_button.dart';
import '../event/verify_code_event.dart';
import '../state/verify_code_state.dart';
import '../viewmodel/verify_code_bloc.dart';
import 'pin_login_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  final String phoneNumber;
  final String tempToken;

  const PhoneLoginScreen({
    Key? key,
    required this.phoneNumber,
    required this.tempToken,
  }) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController codeController = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<VerifyCodeBloc>().add(VerifyCodeStarted(
      phoneNumber: widget.phoneNumber,
      tempToken: widget.tempToken,
    ));

    codeController.addListener(() {
      context.read<VerifyCodeBloc>().add(CodeChanged(codeController.text));

      if (codeController.text.length == 6) {
        Future.delayed(const Duration(milliseconds: 150), () {
          context.read<VerifyCodeBloc>().add(VerifyCodeSubmitted());
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(codeFocusNode);
    });
  }

  void openKeyboard() {
    FocusScope.of(context).requestFocus(codeFocusNode);
  }

  @override
  void dispose() {
    codeController.dispose();
    codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCodeBloc, VerifyCodeState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.go("/pin");
        } else if (state.error != null) {
          codeController.clear();
          FocusScope.of(context).requestFocus(codeFocusNode);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        } else if (state.isBlocked) {
          context.go("/block");
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 310,
                    left: 0,
                    right: 0,
                    child: Image.asset("assets/wave.png", fit: BoxFit.cover),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        "Код отправлен на номер",
                        style: TextStyle(fontSize: 18, color: AppColors.whiteText),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.phoneNumber,
                        style: const TextStyle(fontSize: 20, color: AppColors.whiteText),
                      ),
                      const SizedBox(height: 35),
                      GestureDetector(
                        onTap: openKeyboard,
                        child: CodeDots(
                          code: state.code,
                          length: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Осталось ${state.attemptsLeft} попытк${state.attemptsLeft == 1 ? 'а' : 'и'}",
                        style: const TextStyle(
                          color: AppColors.pinError,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GradientButton(
                        text: state.secondsLeft == 0
                            ? "Отправить код повторно"
                            : "Отправить код повторно\nчерез 00:${state.secondsLeft.toString().padLeft(2, '0')} сек.",
                        onTap: state.secondsLeft == 0
                            ? () {
                          context.read<VerifyCodeBloc>().add(ResendCodePressed());
                        }
                            : () {},
                        enabled: state.secondsLeft == 0,
                        width: 250,
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Opacity(
                          opacity: 0.0,
                          child: TextField(
                            controller: codeController,
                            focusNode: codeFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
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