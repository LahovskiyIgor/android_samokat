import 'package:by_happy/presentation/event/scooter_detail_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../components/custom_app_bar.dart';
import '../components/gradient_button.dart';
import '../components/scooter/battery_indicator.dart';
import '../components/scooter/scooter_info_section.dart';
import '../components/scooter/slide_to_reserve_button.dart';
import '../components/sheet/tariff_sheet.dart';
import '../state/scooter_detail_state.dart';
import '../viewmodel/scooter_detail_bloc.dart';

class ScooterDetailScreen extends StatelessWidget {
  const ScooterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'];
    context.read<ScooterDetailBloc>().add(LoadScooterDetails(int.parse(id!)));
    return Scaffold(
      body: BlocBuilder<ScooterDetailBloc, ScooterDetailState>(
        builder: (context, state) {
          if (state.status == ScooterStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (state.status == ScooterStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Ошибка',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final scooter = state.scooter;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B2A4A), Color(0xFF0F1E3A)],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                bottom: -270,
                right: -200,
                child: Opacity(
                  opacity: 0.3,
                  child: SizedBox(
                    width: 400,
                    height: 500,
                    child: Image.asset(
                      'assets/icons/e6a5dcb6a3e2ec2362c25ea49509ab10d2312b19.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      CustomAppBar(
                        title: scooter?.title != null ? 'Самокат ${scooter!.title}' : 'Самокат',
                      ),
                      const SizedBox(height: 24),

                      BatteryIndicator(percent: (scooter?.batteryLevel ?? 0) / 100),

                      const SizedBox(height: 24),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: ScooterInfoSection()),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),


                      GradientButton(
                        text: "Забронировать",
                        showArrows: true,
                        height: 52,
                        width: double.infinity,
                        fontSize: 16,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const TariffSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
