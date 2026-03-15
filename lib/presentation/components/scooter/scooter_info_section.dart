import 'package:flutter/material.dart';
import 'scooter_info_item.dart';

class ScooterInfoSection extends StatelessWidget {
  const ScooterInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ScooterInfoItem(icon: 'assets/icons/bolt.png', text: '47 км или 4 часа 17 минут'),
        ScooterInfoItem(icon: 'assets/icons/speed.png', text: 'max = 25 км/ч'),
        ScooterInfoItem(icon: 'assets/icons/location.png', text: 'пр. Московский, 33'),
        Row(
          children: [
            ScooterInfoItem(icon: 'assets/icons/person.png', text: '120 м'),
            SizedBox(width: 16),
            ScooterInfoItem(icon: 'assets/icons/time.png', text: '1 минута'),
          ],
        ),
      ],
    );
  }
}