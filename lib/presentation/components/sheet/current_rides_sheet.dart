import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../di/service_locator.dart';
import '../../../domain/entities/scooter_order.dart';
import '../../event/current_rides_event.dart';
import '../../state/current_rides_state.dart';
import '../../viewmodel/current_rides_bloc.dart';
import '../gradient_button.dart';
import 'reserved_ride_sheet.dart';
import 'active_ride_sheet.dart';

class CurrentRidesSheet extends StatefulWidget {
  final int clientId;
  
  const CurrentRidesSheet({super.key, required this.clientId});

  @override
  State<CurrentRidesSheet> createState() => _CurrentRidesSheetState();
}

class _CurrentRidesSheetState extends State<CurrentRidesSheet> {
  late final CurrentRidesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CurrentRidesBloc>();
    _bloc.add(LoadClientOrders(widget.clientId));
  }

  @override
  void dispose() {
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
              height: 450,
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0x00000032).withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            'Текущие поездки',
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
                  Expanded(
                    child: BlocBuilder<CurrentRidesBloc, CurrentRidesState>(
                      builder: (context, state) {
                        if (state.status == CurrentRidesStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }

                        if (state.status == CurrentRidesStatus.failure) {
                          return Center(
                            child: Text(
                              state.errorMessage ?? 'Ошибка загрузки',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (state.orders.isEmpty) {
                          return const Center(
                            child: Text(
                              'Нет активных поездок',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: state.orders.map((order) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _RideCard(order: order),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 56,
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
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: const Center(
                            child: Text(
                              'Взять ещё самокат',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RideCard extends StatefulWidget {
  final ScooterOrder order;

  const _RideCard({required this.order});

  @override
  State<_RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<_RideCard> {
  late Timer _timer;
  late Duration _elapsedTime;
  late Duration _reservationTime;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.order.startAt ?? widget.order.createdAt;
    _elapsedTime = DateTime.now().difference(_startTime);
    _reservationTime = const Duration(minutes: 5);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReserved = widget.order.status == 'Booking' ||    //Drive, Finish
                       widget.order.status == 'holding';
    Duration displayTime;
    if (isReserved) {
      displayTime = _reservationTime - _elapsedTime;
      if (displayTime.isNegative) {
        displayTime = Duration.zero;
      }
    } else {
      displayTime = _elapsedTime;
    }
    final timeString = _formatDuration(displayTime);
    final statusText = _getStatusText(widget.order.status);
    final statusColor = _getStatusColor(widget.order.status);

    final scooterNumber = widget.order.scooter?.number ?? 
                          widget.order.scooterId.toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Image.asset(
              'assets/icons/e6a5dcb6a3e2ec2362c25ea49509ab10d2312b19-reverse.png',
              height: 70,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  scooterNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getLocationText(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeString,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontFamily: 'Digital Numbers',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: GradientButton(
                    text: 'Подробнее',
                    showArrows: false,
                    height: 32,
                    width: 100,
                    fontSize: 11,
                    onTap: () {
                      if (isReserved) {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ReservedRideSheet(
                            orderId: widget.order.id,
                            scooterNumber: scooterNumber,
                            initialReservationTime: _reservationTime - _elapsedTime,
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ActiveRideSheet(
                            scooterNumber: scooterNumber,
                            initialElapsedTime: _elapsedTime,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'reserved':
      case 'holding':
        return 'Забронировано';
      case 'active':
      case 'in_progress':
        return 'Активно';
      case 'completed':
        return 'Завершено';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'reserved':
      case 'holding':
        return const Color(0xFFFFB800);
      case 'active':
      case 'in_progress':
        return const Color(0xFF66E3C4);
      default:
        return Colors.white;
    }
  }

  String _getLocationText() {
    /*if (widget.order.scooter != null && widget.order.scooter!.address != null) {
      return widget.order.scooter!.address!;
    }*/
    return 'Московский 33';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}