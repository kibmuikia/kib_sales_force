import 'package:app_http/utils/api_error.dart';

/// A generic response wrapper for API calls that handles both success and error cases.
///
/// Provides a standardized way to handle API responses with:
/// - Success/error status
/// - Response data
/// - Status messages
/// - Error details
/// - HTTP status codes
class ApiResponse<T> {
  /// The URL path of the API request
  final String url;

  /// The response data of type T, null in case of errors
  final T? data;

  /// A message describing the response outcome
  final String? message;

  /// Whether the API call was successful
  final bool success;

  /// The HTTP status code of the response
  final int? statusCode;

  /// Error details if the API call failed
  final ApiError? apiError;

  /// Creates an API response with the given parameters.
  ApiResponse({
    required this.url,
    this.data,
    this.message,
    this.statusCode,
    this.success = true,
    this.apiError,
  });

  /// Creates a successful API response.
  ///
  /// Parameters:
  /// - [url]: The request URL
  /// - [data]: The response data
  /// - [message]: A success message
  /// - [statusCode]: The HTTP status code
  ///
  /// The [success] flag is automatically set to true.
  factory ApiResponse.success({
    required String url,
    required T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      url: url,
      data: data,
      message: message,
      statusCode: statusCode,
      success: true,
    );
  }

  /// Creates an error API response.
  ///
  /// Parameters:
  /// - [url]: The request URL
  /// - [message]: An error message
  /// - [statusCode]: The HTTP status code
  /// - [apiError]: Detailed error information
  ///
  /// The [success] flag is automatically set to false and [data] to null.
  factory ApiResponse.error({
    required String url,
    String? message,
    int? statusCode,
    required ApiError apiError,
  }) {
    return ApiResponse(
      url: url,
      message: message,
      statusCode: statusCode,
      success: false,
      apiError: apiError,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('ApiResponse(');
    buffer.writeln('  url: $url,');
    buffer.writeln('  success: $success,');
    buffer.writeln('  statusCode: $statusCode,');
    buffer.writeln('  message: $message,');

    if (data != null) {
      buffer.writeln('  data: $data,');
    }

    if (apiError != null) {
      buffer.writeln('  apiError: {');
      buffer.writeln('    message: ${apiError!.message},');
      buffer.writeln('    statusCode: ${apiError!.statusCode},');
      buffer.writeln('    error: ${apiError!.error}');
      buffer.writeln('  }');
    }

    buffer.write(')');
    return buffer.toString();
  }

}
