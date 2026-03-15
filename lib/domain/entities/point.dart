
class Point {
  final double latitude;
  final double longitude;

  Point(this.latitude, this.longitude);

  @override
  String toString() {
    return 'Point{latitude: $latitude, longitude: $longitude}';
  }
}
