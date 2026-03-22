import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/gradient_button.dart';
import '../event/payment_confirm_event.dart';
import '../state/payment_confirm_state.dart';
import '../viewmodel/payment_confirm_bloc.dart';

class PaymentConfirmScreen extends StatelessWidget {
  final int orderId;
  final List<int> photoIds;

  const PaymentConfirmScreen({
    super.key,
    required this.orderId,
    this.photoIds = const [1],
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentConfirmBloc(
        context.read(), // PayRideUsecase из DI
      ),
      child: _PaymentConfirmScreenContent(
        orderId: orderId,
        photoIds: photoIds,
      ),
    );
  }
}

class _PaymentConfirmScreenContent extends StatelessWidget {
  final int orderId;
  final List<int> photoIds;

  const _PaymentConfirmScreenContent({
    required this.orderId,
    required this.photoIds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppBar(title: 'Оплата'),
              ),

              const SizedBox(height: 40),

              // 🔹 ЦЕНТРАЛЬНАЯ КНОПКА
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: BlocConsumer<PaymentConfirmBloc, PaymentConfirmState>(
                      listener: (context, state) {
                        if (state.status == PaymentConfirmStatus.success &&
                            state.paymentCompleted) {
                          // После успешной оплаты переходим на главный экран
                          context.go('/home');
                        } else if (state.status == PaymentConfirmStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage ?? 'Ошибка оплаты'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return GradientButton(
                          text: state.status == PaymentConfirmStatus.loading
                              ? 'Обработка...'
                              : 'Оплатить',
                          showArrows: true,
                          height: 56,
                          width: double.infinity,
                          fontSize: 16,
                          onTap: state.status == PaymentConfirmStatus.loading
                              ? null
                              : () {
                                  context.read<PaymentConfirmBloc>().add(
                                        PayRide(
                                          orderId: orderId,
                                          photoIds: photoIds,
                                        ),
                                      );
                                },
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}