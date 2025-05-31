import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration for development
@Envied(path: '.env.dev', obfuscate: true)
abstract class EnvDev {
  const EnvDev._();
  @EnviedField(varName: 'API_BASE_URL')
  static String baseUrl = _EnvDev.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static String apiKey = _EnvDev.apiKey;
}

/// Environment configuration for production
@Envied(path: '.env.prod', obfuscate: true)
abstract class EnvProd {
  const EnvProd._();
  @EnviedField(varName: 'API_BASE_URL')
  static String baseUrl = _EnvProd.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static String apiKey = _EnvProd.apiKey;
}

/// Environment configuration wrapper
/// Sample usage:
/// ```dart
/// final baseUrl = Env.baseUrl;
/// final apiKey = Env.apiKey;
/// ```
sealed class Env {
  /// Whether we're running in production mode
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  /// Get the base URL for the current environment
  static String get baseUrl {
    final url = isProduction ? EnvProd.baseUrl : EnvDev.baseUrl;
    assert(url.isNotEmpty, 'Base URL cannot be empty');
    return url;
  }

  /// Get the API key for the current environment
  static String get apiKey {
    final key = isProduction ? EnvProd.apiKey : EnvDev.apiKey;
    assert(key.isNotEmpty, 'API key cannot be empty');
    return key;
  }
}
