class ApiError implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiError({
    required this.url,
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() =>
      'ApiError(url: $url, message: $message, statusCode: $statusCode, error: $error)';
}
