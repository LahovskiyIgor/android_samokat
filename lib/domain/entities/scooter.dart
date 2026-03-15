
class Scooter {
  final int id;
  final String title;
  final String status;
  final double latitude;
  final double longitude;
  final int batteryLevel;
  final bool isOnline;
  final int maxSpeed;
  final String number;
  double? distance;
  double? timeToTravel;

  Scooter({
    required this.id,
    required this.title,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
    required this.isOnline,
    required this.maxSpeed,
    required this.number,
    this.distance,
    this.timeToTravel,
  });

  factory Scooter.fromJson(Map<String, dynamic> json) {
    final scooterDetail = json['scooterDetail'] as Map<String, dynamic>? ?? {};
    final model = json['model'] as Map<String, dynamic>? ?? {};

    return Scooter(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      status: json['status'] ?? 'Unavailable',
      latitude: (scooterDetail['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (scooterDetail['longitude'] as num?)?.toDouble() ?? 0.0,
      batteryLevel: (scooterDetail['batteryLevel'] as num?)?.toInt() ?? 0,
      isOnline: scooterDetail['isOnline'] ?? false,
      maxSpeed: (json['maxSpeed'] as num?)?.toInt() ?? 25,
      number: json['title'] ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return 'Scooter{id: $id, title: $title}';
  }
}
