import 'dart:ui';
import 'package:by_happy/presentation/components/scooter/mini_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/scooter.dart';
import '../../state/scooter_detail_modal_state.dart';
import '../../viewmodel/scooter_detail_modal_bloc.dart';
import '../gradient_button.dart';

class ScooterData {
  final String distance;
  final String number;
  final double batteryPercent;

  ScooterData({
    required this.distance,
    required this.number,
    required this.batteryPercent,
  });
}

class ScooterBottomSheet extends StatefulWidget {

  const ScooterBottomSheet({super.key});

  @override
  State<ScooterBottomSheet> createState() => _ScooterBottomSheetState();
}

class _ScooterBottomSheetState extends State<ScooterBottomSheet> {

  final PageController _pageController = PageController(viewportFraction: 0.5);
  double _currentPage = 0;

  _ScooterBottomSheetState();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScooterDetailModalBloc, ScooterDetailModalState>(
      builder: (context, state) {
        if (state.status == ScooterDetailModalStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state.status == ScooterDetailModalStatus.success) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 320,
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000032).withOpacity(0.88),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header с адресом (без изменений)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_sharp, color: const Color(0x99FFFFFF), size: 20),
                                  Icon(Icons.arrow_back_ios_sharp, color: const Color(0x66FFFFFF), size: 20),
                                  Icon(Icons.arrow_back_ios_sharp, color: const Color(0x22FFFFFF), size: 20),
                                ],
                              )
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.address ?? "Unknown address",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // PageView с динамическим списком
                      SizedBox(
                        height: 220,
                        child: PageView.builder(
                          controller: _pageController,
                          padEnds: false, // Оставляем false, чтобы первый элемент прилипал к левому краю
                          itemCount: state.scooters!.length,
                          itemBuilder: (context, index) {
                            final scooter = state.scooters![index];
                            final diff = (_currentPage - index).abs();
                            final isActive = diff < 0.5;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              // 2. Добавляем левый отступ ТОЛЬКО для первого элемента,
                              // чтобы он совпадал с заголовком
                              margin: EdgeInsets.only(
                                left: index == 0 ? 10 : 0,
                                right: 10,
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Transform.scale(
                                  scale: isActive ? 1.0 : 0.9,
                                  child: _ScooterCard(
                                    scooter: scooter,
                                    isActive: isActive,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: Text("Error"));
      },
    );
  }
}

class _ScooterCard extends StatelessWidget {
  final Scooter scooter;
  final bool isActive;

  const _ScooterCard({required this.scooter, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(isActive ? 0.35 : 0.25),
                Colors.white.withOpacity(isActive ? 0.25 : 0.18),
               ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${(scooter.distance?.toInt()) ?? 0}m",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.qr_code_scanner_outlined, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    scooter.number,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  MiniBatteryIndicator(percent: scooter.batteryLevel),
                  const SizedBox(width: 8),
                  Transform.translate(
                    offset: const Offset(-40, 0),
                    child: Text(
                      '${(scooter.batteryLevel)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              GradientButton(
                text: "Подробнеe",
                showArrows: true,
                height: 32,
                width: double.infinity,
                fontSize: 12,
                onTap: () {
                  Navigator.pop(context, scooter);
                },
              ),

            ],
          ),
        ),

        Positioned(
          right: isActive ? -30 : -5,
          top: isActive ? -10 : 15,
          child: SizedBox(
            height: isActive ? 190 : 160,
            child: Image.asset(
              "assets/icons/e6a5dcb6a3e2ec2362c25ea49509ab10d2312b19-reverse.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
