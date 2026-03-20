class NewsEntity {
  final int id;
  final String title;
  final String previewText;
  final String text;
  final DateTime createdAt;
  final DateTime publishedAt;
  final bool isActive;
  final String? imageUrl;

  NewsEntity({
    required this.id,
    required this.title,
    required this.previewText,
    required this.text,
    required this.createdAt,
    required this.publishedAt,
    required this.isActive,
    this.imageUrl,
  });

  factory NewsEntity.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(String? dateStr) {
      try {
        return dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
      } catch (_) {
        return DateTime.now();
      }
    }

    return NewsEntity(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      previewText: json['previewText'] ?? '',
      text: json['text'] ?? '',
      createdAt: _parseDate(json['createdAt']),
      publishedAt: _parseDate(json['publishedAt']),
      isActive: json['isActive'] ?? false,
      imageUrl: json['picture'] != null
          ? 'https://sharing-api.sparkit.by/${json['picture']['path']}'
          : null,
    );
  }
}