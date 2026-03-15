class Pagination {
  final int total;
  final int currentPage;
  final int lastPage;

  Pagination({
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      lastPage: json['lastPage'] ?? 0,
    );
  }
}