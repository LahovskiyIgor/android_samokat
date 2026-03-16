import 'package:by_happy/domain/entities/tariff.dart';

class TariffsResponse {
  final List<Tariff> tariffs;

  TariffsResponse({required this.tariffs});

  factory TariffsResponse.fromJson(Map<String, dynamic> json) {
    return TariffsResponse(
      tariffs: (json['data'] as List<dynamic>)
          .map((e) => Tariff.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
