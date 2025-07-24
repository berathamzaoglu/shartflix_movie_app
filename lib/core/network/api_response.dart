class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? parser,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      data: parser != null && json['data'] != null 
          ? parser(json['data']) 
          : json['data'],
      message: json['message'],
      statusCode: json['status_code'],
    );
  }
}

// Paginated Response Model
class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    return PaginatedResponse<T>(
      items: (json['movies'] as List? ?? [])
          .map((item) => itemParser(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
    );
  }
} 