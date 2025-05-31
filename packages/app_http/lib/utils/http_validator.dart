import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// Utility class to validate HTTP status codes
class HttpValidator {
  const HttpValidator._();

  /// Validates if a given HTTP status code is considered valid for processing
  ///
  /// Returns true if the status code is valid for further processing,
  /// false otherwise.
  static bool isValidStatus(int? status) {
    try {
      if (status == null) return false;

      switch (status) {
        // 2xx Success
        case >= 200 && < 300:
          return true;

        // Specific status codes that need custom handling
        case 304: // Not Modified
        case 409: // Conflict
        case 422: // Unprocessable Entity
          return true;

        // Unauthorized, Forbidden & Not Found
        case 401:
        case 403:
        case 404:
          return false;

        // All other status codes are considered invalid
        default:
          return false;
      }
    } on Exception catch (e) {
      debugPrint('** HttpValidator:isValidStatus: $e *');
      return false;
    }
  }

  /// Checks if status code is in success range (2xx)
  static bool isSuccess(int? status) {
    return status != null && status >= 200 && status < 300;
  }

  /// Checks if status code is in client error range (4xx)
  static bool isClientError(int? status) {
    return status != null && status >= 400 && status < 500;
  }

  /// Checks if status code is in server error range (5xx)
  static bool isServerError(int? status) {
    return status != null && status >= 500 && status < 600;
  }

  /// Provides a description for common HTTP status codes
  static String getStatusDescription(int? status) {
    try {
      if (status == null) return 'Invalid Status Code';
      switch (status) {
        case 200:
          return 'OK';
        case 201:
          return 'Created';
        case 204:
          return 'No Content';
        case 304:
          return 'Not Modified';
        case 400:
          return 'Bad Request';
        case 401:
          return 'Unauthorized';
        case 403:
          return 'Forbidden';
        case 404:
          return 'Not Found';
        case 409:
          return 'Conflict';
        case 422:
          return 'Unprocessable Entity';
        case 500:
          return 'Internal Server Error';
        case 502:
          return 'Bad Gateway';
        case 503:
          return 'Service Unavailable';
        case 504:
          return 'Gateway Timeout';
        default:
          return 'Unknown Status Code ($status)';
      }
    } on Exception catch (e) {
      return kDebugMode ? 'Error: $e' : 'Error Encountered';
    }
  }
}

/// Extension methods for int to easily check HTTP status codes
extension HttpStatusExtension on int? {
  /// Check if this status code is valid
  bool get isValidHttpStatus => HttpValidator.isValidStatus(this);

  /// Check if this status code represents a success (2xx)
  bool get isHttpSuccess => HttpValidator.isSuccess(this);

  /// Check if this status code represents a client error (4xx)
  bool get isHttpClientError => HttpValidator.isClientError(this);

  /// Check if this status code represents a server error (5xx)
  bool get isHttpServerError => HttpValidator.isServerError(this);

  /// Get description for this HTTP status code
  String get httpStatusDescription => HttpValidator.getStatusDescription(this);
}
