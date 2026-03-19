import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../di/service_locator.dart';
import '../../event/reserved_ride_event.dart';
import '../../state/reserved_ride_state.dart';
import '../../viewmodel/reserved_ride_bloc.dart';
import '../gradient_button.dart';
import 'active_ride_sheet.dart';

class ReservedRideSheet extends StatefulWidget {
  final String scooterNumber;
  final int orderId;
  final Duration initialReservationTime;
  
  const ReservedRideSheet({
    super.key,
    required this.scooterNumber,
    required this.orderId,
    this.initialReservationTime = const Duration(minutes: 3, seconds: 17),
  });

  @override
  State<ReservedRideSheet> createState() => _ReservedRideSheetState();
}

class _ReservedRideSheetState extends State<ReservedRideSheet> {
  late final ReservedRideBloc _bloc;
  late Duration _reservationTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ReservedRideBloc>();
    _reservationTime = widget.initialReservationTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _reservationTime = _reservationTime - const Duration(seconds: 1);
          if (_reservationTime.isNegative) {
            _reservationTime = Duration.zero;
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF000032).withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_sharp,
                                color: const Color(0x99FFFFFF),
                                size: 20,
                              ),
                              Icon(
                                Icons.arrow_back_ios_sharp,
                                color: const Color(0x66FFFFFF),
                                size: 20,
                              ),
                              Icon(
                                Icons.arrow_back_ios_sharp,
                                color: const Color(0x22FFFFFF),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Бесплатное бронирование',
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

                  // ТАЙМЕР + ИНФО О САМОКАТЕ (КОМПАКТНЫЙ)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Таймер
                        Expanded(
                          flex: 2,
                          child: Text(
                            _formatDuration(_reservationTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                              fontFamily: 'Digital Numbers',
                            ),
                          ),
                        ),
                        // Иконка и информация (ВЫСОКИЙ БЛОК)
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Иконка самоката (ВЫШЕ)
                                SizedBox(
                                  width: 44,
                                  height: 56,
                                  child: Image.asset(
                                    'assets/icons/e6a5dcb6a3e2ec2362c25ea49509ab10d2312b19-reverse.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Инфо
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFFB800),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'Забронирован',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '№${widget.scooterNumber}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // КНОПКА "НАЧАТЬ ПОЕЗДКУ"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocListener<ReservedRideBloc, ReservedRideState>(
                      listener: (context, state) {
                        if (state.rideStarted) {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ActiveRideSheet(
                              scooterNumber: widget.scooterNumber,
                              initialElapsedTime: Duration.zero,
                            ),
                          );
                        } else if (state.status == ReservedRideStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage ?? 'Ошибка')),
                          );
                        }
                      },
                      child: GradientButton(
                        text: 'Начать поездку',
                        showArrows: true,
                        height: 48,
                        width: double.infinity,
                        fontSize: 15,
                        onTap: () {
                          _bloc.add(StartRide(widget.orderId));
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // КНОПКА "ОТМЕНИТЬ БРОНИРОВАНИЕ"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocListener<ReservedRideBloc, ReservedRideState>(
                      listener: (context, state) {
                        if (state.rideCancelled) {
                          Navigator.pop(context);
                        } else if (state.status == ReservedRideStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage ?? 'Ошибка')),
                          );
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _bloc.add(CancelRide(widget.orderId));
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: BlocBuilder<ReservedRideBloc, ReservedRideState>(
                              builder: (context, state) {
                                if (state.status == ReservedRideStatus.loading) {
                                  return const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: Text(
                                    'Отменить бронирование',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
