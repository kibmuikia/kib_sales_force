import 'dart:async' show FutureOr;

import 'package:app_http/utils/api_error.dart' show ApiError;
import 'package:dio/dio.dart' show DioException;

class ApiConstants {
  const ApiConstants._();

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // Headers
  static const String contentType = 'Content-Type';
  static const String apiKeyHeader = 'apikey';
}

const String errorEncountered = "Error Encountered";
const String success = "Success";

/// Type definition for response transformation function
typedef ResponseTransformer<T> = FutureOr<T> Function(T data);

/// Type definition for custom error handling function
typedef DioExceptionHandler = Future<ApiError> Function(
    String url, DioException error);
