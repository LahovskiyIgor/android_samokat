import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../gradient_button.dart';
import 'reserved_ride_sheet.dart';
import 'active_ride_sheet.dart';

class CurrentRidesSheet extends StatefulWidget {
  const CurrentRidesSheet({super.key});

  @override
  State<CurrentRidesSheet> createState() => _CurrentRidesSheetState();
}

class _CurrentRidesSheetState extends State<CurrentRidesSheet> {
  final List<Ride> _rides = [
    Ride(
      id: 1,
      scooterNumber: '123-456',
      status: RideStatus.reserved,
      startTime: DateTime.now(),
      location: '',
    ),
    Ride(
      id: 2,
      scooterNumber: '654-321',
      status: RideStatus.active,
      startTime: DateTime.now(),
      location: 'Старт',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _rides.map((ride) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RideCard(ride: ride),
                        );
                      }).toList(),
                    ),
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
    );
  }
}

class Ride {
  final int id;
  final String scooterNumber;
  final RideStatus status;
  final DateTime startTime;
  final String location;

  Ride({
    required this.id,
    required this.scooterNumber,
    required this.status,
    required this.startTime,
    required this.location,
  });
}

enum RideStatus {
  reserved,
  active,
}

class _RideCard extends StatefulWidget {
  final Ride ride;

  const _RideCard({required this.ride});

  @override
  State<_RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<_RideCard> {
  late Timer _timer;
  late Duration _elapsedTime;
  late Duration _reservationTime;

  @override
  void initState() {
    super.initState();
    _elapsedTime = DateTime.now().difference(widget.ride.startTime);
    _reservationTime = const Duration(minutes: 5);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = DateTime.now().difference(widget.ride.startTime);
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
    final isReserved = widget.ride.status == RideStatus.reserved;
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
    final statusText = isReserved ? 'Забронировано' : 'Активно';
    final statusColor = isReserved
        ? const Color(0xFFFFB800)
        : const Color(0xFF66E3C4);

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
                  widget.ride.scooterNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.ride.location,
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
                            scooterNumber: widget.ride.scooterNumber,
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
                            scooterNumber: widget.ride.scooterNumber,
                            initialElapsedTime: _elapsedTime, // ✅ Передаем время
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}