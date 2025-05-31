import 'package:dio_smart_retry/dio_smart_retry.dart' show RetryEvaluator;

/// Configuration options for retry mechanism
class RetryOptions {
  /// Number of retry attempts
  final int retries;

  /// Delays between retry attempts
  final List<Duration> retryDelays;

  /// Custom retry evaluator function
  final RetryEvaluator? retryEvaluator;

  /// Additional HTTP status codes that should trigger retry
  final Set<int>? retryableExtraStatuses;

  const RetryOptions({
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
    this.retryEvaluator,
    this.retryableExtraStatuses,
  });
}
