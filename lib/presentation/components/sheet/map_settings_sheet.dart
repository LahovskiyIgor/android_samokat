import 'dart:ui';
import 'package:by_happy/presentation/event/map_event.dart';
import 'package:by_happy/presentation/event/map_settings_modal_event.dart';
import 'package:by_happy/presentation/state/map_settings_modal_state.dart';
import 'package:by_happy/presentation/viewmodel/map_settings_modal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodel/map_bloc.dart';

class MapSettingsSheet extends StatelessWidget {
  final VoidCallback? onClose;

  const MapSettingsSheet({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapSettingsModalBloc, MapSettingsModalState>(
      builder: (context, state) {
        final List<_SettingItemData> items = [
          _SettingItemData(
            label: 'Геоточки',
            icon: Icons.location_on_outlined,
            color: const Color(0xFF66E3C4),
            isActive: state.isAllGeomarksActive,
            onChanged: (val) => context.read<MapSettingsModalBloc>().add(AllGeomarksToggled(val)),
          ),
          _SettingItemData(
            label: 'Геозоны',
            icon: Icons.gps_fixed_outlined,
            color: const Color(0xFF86EFAC),
            isActive: state.isAllGeozonesActive,
            onChanged: (val) => context.read<MapSettingsModalBloc>().add(AllGeozonesToggled(val)),
          ),
          _SettingItemData(
            label: 'Парковка',
            icon: Icons.home_outlined,
            color: const Color(0xFFA78BFA),
            isActive: state.isParkingZoneActive,
            onChanged: (val) => context.read<MapSettingsModalBloc>().add(ParkingZonesToggled(val)),
          ),
          _SettingItemData(
            label: 'Парковка запрещена',
            icon: Icons.block_outlined,
            color: const Color(0xFFF59E0B),
            isActive: state.isRestrictedParkingZoneActive,
            onChanged: (val) => context.read<MapSettingsModalBloc>().add(RestrictedParkingZonesToggled(val)),
          ),
          _SettingItemData(
            label: 'Запрещено кататься',
            icon: Icons.warning_amber_outlined,
            color: const Color(0xFFEF4444),
            isActive: state.isRestrictedDrivingZoneActive,
            onChanged: (val) => context.read<MapSettingsModalBloc>().add(RestrictedDrivingZonesToggled(val)),
          ),
        ];

        return Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 365,
                decoration: BoxDecoration(
                  color: const Color(0xFF000032).withOpacity(0.88),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Параметры карты',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<MapSettingsModalBloc>().add(ApllyButtonClick());
                              context.read<MapBloc>().add(UpdateMap());
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Готово',
                              style: TextStyle(color: Color(0xFF66E3C4), fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            leading: Icon(item.icon, color: item.color),
                            title: Text(item.label, style: const TextStyle(color: Colors.white)),
                            trailing: Switch.adaptive(
                              value: item.isActive,
                              onChanged: item.onChanged,
                              activeTrackColor: const Color(0xFF66E3C4),
                              inactiveThumbColor: Colors.white,
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
      },
    );
  }
}

// Вспомогательный класс для описания строк
class _SettingItemData {
  final String label;
  final IconData icon;
  final Color color;
  final bool isActive;
  final ValueChanged<bool> onChanged;

  _SettingItemData({
    required this.label,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onChanged,
  });
}
