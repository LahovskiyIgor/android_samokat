import 'dart:convert';

import 'package:by_happy/domain/entities/point.dart';

class Zone {
  final int id;
  final String title;
  final String description;
  final String type;
  final bool isActive;
  final String shapeType;
  final List<Point> points;
  final String speedLimit;

  Zone({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isActive,
    required this.shapeType,
    required this.points,
    required this.speedLimit,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    final zoneCoordinates = json['coordinates'] as Map<String, dynamic>? ?? {};
    final String coordsString = zoneCoordinates['coordinates'] ?? '[]';
    final String shapeType = zoneCoordinates['type'] ?? 'Polygon';

    List<Point> points = [];

    try {
      final dynamic decoded = jsonDecode(coordsString);

      if (decoded is List && decoded.isNotEmpty) {
        List<dynamic> targetList = [];

        if (shapeType == 'Polygon') {
          // У полигона структура [[[lat, lon], ...]] -> уходим на 1 уровень вглубь
          targetList = decoded[0] as List<dynamic>;
        } else {
          // У LineString структура [[lat, lon], ...] -> используем как есть
          targetList = decoded;
        }

        points = targetList.map((item) {
          final List<dynamic> coords = item as List<dynamic>;
          return Point(
            (coords[0] as num).toDouble(),
            (coords[1] as num).toDouble(),
          );
        }).toList();
      }
    } catch (e) {
      print("PARSE ERROR for Zone ID ${json['id']}: $e");
    }

    return Zone(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      isActive: json['isActive'] ?? false,
      speedLimit: json['speedLimit'] ?? '',
      shapeType: shapeType,
      points: points,
    );
  }
  @override
  String toString() {
    return 'Zone{id: $id, title: $title, type: $type, points: $points}';
  }
}
