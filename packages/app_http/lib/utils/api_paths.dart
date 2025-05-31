enum ApiVersion {
  v1('v1');

  final String value;

  const ApiVersion(this.value);
}

enum ResourceType {
  auth('auth'),
  customers('customers'),
  visits('visits'),
  activities('activities');

  final String value;

  const ResourceType(this.value);
}

abstract class BaseEndpoint {
  /// The API version this endpoint belongs to (e.g, v1)
  final ApiVersion version;

  /// The resource category this endpoint belongs to (e.g., customers)
  final ResourceType resource;

  /// The specific path segment for this endpoint
  /// Can include path parameters denoted by colon prefix (e.g., ':userId')
  final String path;

  /// Whether this endpoint requires authentication
  /// Defaults to true as most endpoints require auth
  final bool requiresAuth;

  const BaseEndpoint({
    required this.version,
    required this.resource,
    required this.path,
    this.requiresAuth = true,
  });

  /// Builds the complete endpoint path by combining version, resource and path segments.
  ///
  /// Returns a URL path in the format:
  /// - With path: /{version}/{resource}/{path}
  /// - Without path: /{version}/{resource}
  String build() => path.isEmpty
      ? '/${version.value}/${resource.value}'
      : '/${version.value}/${resource.value}/$path';

  @override
  String toString() => build();

  /// Appends query parameters to the endpoint URL.
  ///
  /// [params] - Map of query parameter names to their values
  ///
  /// Returns the complete URL with encoded query parameters.
  /// If [params] is empty, returns the basic endpoint URL.
  String withQuery(Map<String, dynamic> params) {
    if (params.isEmpty) return build();

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return '${build()}?$queryString';
  }

  /// Replaces path parameters in the endpoint URL with provided values.
  ///
  /// [params] - Map of parameter names to their replacement values
  ///
  /// Returns the URL with all path parameters replaced.
  /// Path parameters in the URL must be prefixed with ':' to be replaced.
  String withParams(Map<String, dynamic> params) {
    String finalPath = build();
    params.forEach((key, value) {
      finalPath = finalPath.replaceAll(':$key', value.toString());
    });
    return finalPath;
  }
}

class CustomersEndpoints {
  static const customers = _CustomersEndpoint('');
  static const customer = _CustomersEndpoint(':customerId');
}

class _CustomersEndpoint extends BaseEndpoint {
  const _CustomersEndpoint(String path)
      : super(
          version: ApiVersion.v1,
          resource: ResourceType.customers,
          path: path,
        );
}

class ActivitiesEndpoints {
  static const activities = _ActivitiesEndpoint('');
  static const activity = _ActivitiesEndpoint(':activityId');
}

class _ActivitiesEndpoint extends BaseEndpoint {
  const _ActivitiesEndpoint(String path)
      : super(
          version: ApiVersion.v1,
          resource: ResourceType.activities,
          path: path,
        );
}

class VisitsEndpoints {
  static const visits = _VisitsEndpoint('');
  static const visit = _VisitsEndpoint(':visitId');
}

class _VisitsEndpoint extends BaseEndpoint {
  const _VisitsEndpoint(String path)
      : super(
          version: ApiVersion.v1,
          resource: ResourceType.visits,
          path: path,
        );
}
