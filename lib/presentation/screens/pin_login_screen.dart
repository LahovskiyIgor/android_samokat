import 'package:by_happy/presentation/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../components/code_dots.dart';
import '../event/spalsh_event.dart';
import '../viewmodel/pin_bloc.dart';
import '../event/pin_event.dart';
import '../state/pin_state.dart';
import '../viewmodel/splash_bloc.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    context.read<SplashBloc>().add(AuthCheckRequested());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = controller.text;

    context.read<PinCreateBloc>().add(
      PinDigitChanged(text),
    );

    if (text.length == 6) {
      context.read<PinCreateBloc>().add(
        PinSubmitted(text),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PinCreateBloc, PinCreateState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.go("/home");
        }

        if (state.error != null) {
          controller.clear();
          focusNode.requestFocus();
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.phoneScreenBg,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 310,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/wave.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        "Создайте PIN-код",
                        style: TextStyle(
                          color: AppColors.whiteText,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 35),

                      GestureDetector(
                        onTap: () => focusNode.requestFocus(),
                        child: BlocBuilder<PinCreateBloc, PinCreateState>(
                          buildWhen: (prev, curr) => prev.pin != curr.pin,
                          builder: (context, state) {
                            return CodeDots(
                              code: state.pin, // текущий ввод PIN
                              length: 6,
                            );
                          },
                        ),
                      ),


                      const SizedBox(height: 12),

                      BlocBuilder<PinCreateBloc, PinCreateState>(
                        buildWhen: (prev, curr) =>
                        prev.error != curr.error,
                        builder: (context, state) {
                          if (state.error == null) return const SizedBox();

                          return Column(
                            children: [
                              Text(
                                state.error!,
                                style: const TextStyle(
                                  color: AppColors.pinError,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Запомните PIN-код",
                        style: TextStyle(
                          color: AppColors.white70,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          autofocus: true,
                          decoration:
                          const InputDecoration(counterText: ""),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
