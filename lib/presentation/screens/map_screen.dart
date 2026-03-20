import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:by_happy/domain/usecase/book_scooter_usecase.dart';
import 'package:by_happy/domain/usecase/get_map_settings_usecase.dart';
import 'package:by_happy/domain/usecase/get_payment_cards_usecase.dart';
import 'package:by_happy/domain/usecase/get_pedestrian_routes_usecase.dart';
import 'package:by_happy/domain/usecase/get_scooter_usecase.dart';
import 'package:by_happy/domain/usecase/save_map_settings_usecase.dart';
import 'package:by_happy/presentation/components/map_icon_painter/clusterized_icon_painter.dart';
import 'package:by_happy/presentation/components/sheet/current_rides_sheet.dart';
import 'package:by_happy/presentation/components/sheet/map_settings_sheet.dart';
import 'package:by_happy/presentation/components/sheet/tariff_sheet.dart';
import 'package:by_happy/presentation/event/map_settings_modal_event.dart';
import 'package:by_happy/presentation/viewmodel/map_settings_modal_bloc.dart';
import 'package:by_happy/presentation/viewmodel/tariff_sheet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../core/app_colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entities/scooter.dart';
import '../../domain/entities/zone.dart';
import '../../domain/usecase/get_address_by_point_usecase.dart';
import '../../domain/usecase/get_available_tariffs_usecase.dart';
import '../components/sheet/scooter_bottom_sheet.dart';
import '../components/side_menu.dart';
import '../event/map_event.dart';
import '../event/scooter_detail_modal_event.dart';
import '../state/map_state.dart';
import '../viewmodel/map_bloc.dart';
import '../viewmodel/scooter_detail_modal_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  YandexMapController? mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _initScooterIcon();
  }

  void _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      if (mapController != null && mounted) {
        await _moveCameraToPoint(position.latitude, position.longitude);
        _fetchScooters();
      }
    } catch (e) {
      debugPrint('Ошибка геолокации: $e');
    }
  }

  // Метод для вызова события BLoC
  void _fetchScooters() async {
    final controller = mapController;
    if (controller == null) return;

    final visibleRegion = await controller.getVisibleRegion();

    print("region: $visibleRegion");

    final area = [
      visibleRegion.topLeft.latitude,
      visibleRegion.topLeft.longitude,
      visibleRegion.bottomRight.latitude,
      visibleRegion.bottomRight.longitude,
    ];


    if (mounted) {
      context.read<MapBloc>().add(FetchScooters(area));
    }
  }

  Future<void> _moveCameraToPoint(
      double lat,
      double lon, {
        double zoom = 15,
      }) async {
    await mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: lat, longitude: lon),
          zoom: zoom,
        ),
      ),
    );
  }

  void _onMarkerTap(List<Scooter> scooters) async {
    final scoot = await showModalBottomSheet<Scooter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) {
        return BlocProvider(
          create: (context) =>
          ScooterDetailModalBloc(
            getIt<GetAddressByPointUsecase>(),
            getIt<GetScooterUsecase>(),
            getIt<GetPedestrianRoutesUsecase>(),
          )..add(
            ScooterDetailModalStarted(
              scooters,
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
          ),
          child: ScooterBottomSheet(),
        );
      },
    );
    bool? isBooking = false;
    if (scoot != null) {

      final result = await context.push('/home/scooter/${scoot.id}');

      if (result == true) {
        // Даем небольшую задержку, чтобы навигация завершилась корректно
        await Future.delayed(Duration(milliseconds: 300), () async {
          isBooking = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            builder: (context) => BlocProvider(
              create: (context) => TariffSheetBloc(getIt<GetAvailableTariffsUsecase>(), getIt<GetPaymentCardsUsecase>(), getIt<BookScooterUsecase>()),
              child: TariffSheet(scooter: scoot),
            ),
          );
        });
      }
    }

    if (isBooking ?? false) {
      showModalBottomSheet(
        context: context,
        builder: (context) => CurrentRidesSheet(clientId: 1),
      );
    }
  }

  void _onMapSettingsTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => MapSettingsModalBloc(
            getIt<GetMapSettingsUsecase>(),
            getIt<SaveMapSettingsUsecase>(),
          )..add(MapSettingsModalStarted()),
          child: MapSettingsSheet(),
        );
      },
    );
  }

  void _onNotificationTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CurrentRidesSheet(clientId: 1),
    );
  }



  void _initScooterIcon() async {
    await ClusterIconPainter.initImage('assets/icons/scooter_placemark.png');
  }

  List<PlacemarkMapObject> _buildScooterPlacemarks(
      List<Scooter> scooters,
      String address,
      ) {
    return scooters.map((scooter) {
      return PlacemarkMapObject(
        mapId: MapObjectId('${scooter.id}'),
        point: Point(latitude: scooter.latitude, longitude: scooter.longitude),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/icons/scooter_placemark_fill.png',
            ),
            scale: 0.2,
          ),
        ),
        opacity: 1.0,
        onTap: (object, point) async => {
          _onMarkerTap([scooter])
        },
      );
    }).toList();
  }

  List<PolygonMapObject> _buildZonePolygons(List<Zone>? zones) {
    if (zones == null || zones.isEmpty) return [];

    return zones
        .map((zone) {
      Color strokeColor = Color(0xFF86EFAC), fillColor = Color(0xFF86EFAC);

      if (zone.type == "Drive") {
        strokeColor = const Color(0xFF1A73E8);
        fillColor = (const Color(0xFF1A73E8)).withOpacity(0.15);
      } else if (zone.type == "NotDrive") {
        strokeColor = const Color(0xFFEF4444);
        fillColor = (const Color(0xFFEF4444)).withOpacity(0.15);
      } else if (zone.type == "Finish") {
        strokeColor = const Color(0xFFA78BFA);
        fillColor = (const Color(0xFFA78BFA)).withOpacity(0.15);
      }

      return PolygonMapObject(
        mapId: MapObjectId('zone_${zone.id}'),
        polygon: Polygon(
          outerRing: LinearRing(
            points: zone.points.map((point) {
              return Point(
                latitude: point.latitude,
                longitude: point.longitude,
              );
            }).toList(),
          ),
          innerRings: [],
        ),
        strokeColor: strokeColor,
        strokeWidth: 2,
        fillColor: fillColor,
        zIndex: 0,
      );
    })
        .whereType<PolygonMapObject>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: const SideMenu(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<MapBloc, ScooterState>(
                builder: (context, state) {
                  final scooters = _buildScooterPlacemarks(
                    state.scooters,
                    state.address ?? "Unknown address",
                  );

                  final zonePolygons = _buildZonePolygons(state.zones);

                  return YandexMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      if (_currentPosition != null) {
                        _fetchScooters();
                      }
                    },
                    onCameraPositionChanged:
                        (cameraPosition, reason, finished) {
                      if (finished) {
                        _fetchScooters();
                      }
                    },
                    mapObjects: [
                      ...zonePolygons,
                      ClusterizedPlacemarkCollection(
                        mapId: const MapObjectId('scooters_cluster'),
                        placemarks: scooters,
                        radius: 30,
                        minZoom: 15,
                        consumeTapEvents: true,
                        onClusterTap: (collection, cluster) {
                          final clusteredPlacemarks = cluster.placemarks;

                          print("filter start");

                          final filtered = state.scooters.where((scooter) {
                            return clusteredPlacemarks.any((pm) {
                              print("Placemark id - ${pm.mapId.value}");
                              print("Scooter id - ${scooter.id}");
                              return pm.mapId.value == scooter.id.toString();
                            });
                          }).toList();

                          print("FILTERED SCOOTERS: $filtered");

                          _onMarkerTap(filtered);

                        },
                        onClusterAdded: (self, cluster) async {
                          return cluster.copyWith(
                            appearance: cluster.appearance.copyWith(
                              opacity: 1.0,
                              icon: PlacemarkIcon.single(
                                PlacemarkIconStyle(
                                  image: BitmapDescriptor.fromBytes(
                                    await ClusterIconPainter(
                                      cluster.size,
                                    ).getClusterIconBytes(),
                                  ),
                                  scale: 0.8,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              BlocBuilder<MapBloc, ScooterState>(
                builder: (context, state) {
                  if (state.status == ScooterStatus.loading) {
                    return const Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Кнопки управления (Меню, Уведомления)
              _buildTopButtons(),

              // Кнопка "Моё местоположение"
              if (_currentPosition != null)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CircleIconButton(
                          icon: Icons.map,
                          onPressed: _onMapSettingsTap,
                        ),
                        const SizedBox(height: 16),
                        _CircleIconButton(
                          icon: Icons.my_location,
                          onPressed: () {
                            _moveCameraToPoint(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                              zoom: 17,
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButtons() {
    return Stack(
      children: [
        Positioned(
          top: 16,
          left: 16,
          child: Builder(
            builder: (innerContext) => _RoundIconButton(
              icon: Icons.menu,
              onPressed: () => Scaffold.of(innerContext).openDrawer(),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: _RoundIconButton(
            icon: Icons.notifications_sharp,
            onPressed: _onNotificationTap,
          ),
        ),
      ],
    );
  }
}

Future<Uint8List> painterToBytes(CustomPainter painter, Size size) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  painter.paint(canvas, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}