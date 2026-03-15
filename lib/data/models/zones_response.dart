import '../../domain/entities/pagination.dart';
import '../../domain/entities/scooter.dart';
import '../../domain/entities/zone.dart';

class ZonesResponse {
  final List<Zone> zones;
  final Pagination pagination;

  ZonesResponse({
    required this.zones,
    required this.pagination,
  });

  factory ZonesResponse.fromJson(Map<String, dynamic> json) {
    return ZonesResponse(
      zones: (json['data'] as List<dynamic>)
          .map((e) => Zone.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}