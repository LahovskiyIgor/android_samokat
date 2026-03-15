import '../../domain/entities/pagination.dart';
import '../../domain/entities/scooter.dart';

class ScootersResponse {
  final List<Scooter> scooters;
  final Pagination pagination;

  ScootersResponse({
    required this.scooters,
    required this.pagination,
  });

  factory ScootersResponse.fromJson(Map<String, dynamic> json) {
    return ScootersResponse(
      scooters: (json['data'] as List<dynamic>)
          .map((e) => Scooter.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}