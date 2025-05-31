import 'package:objectbox/objectbox.dart' show Query, Box;

/// A generic manager for handling and caching ObjectBox [Query] instances
/// associated with a specific type.
///
/// The `DaoQueryManager` is designed to simplify query management for ObjectBox
/// Data Access Objects (DAOs). It provides functionality to cache, retrieve,
/// and close queries efficiently, reducing the overhead of creating
/// and closing queries repeatedly.
///
/// It works by storing [Query] objects in an internal cache, identified
/// by an [Enum] key, allowing you to reuse queries across your application.
///
/// Type Parameters:
/// - `T`: The type of the objects that this manager handles within the
///   bound [Box].
///
/// Example Usage:
/// ```dart
/// final box = objectBox.store.box<MyEntity>();
/// final queryManager = DaoQueryManager<MyEntity>(box);
///
/// Create and cache a query
/// final query = box.query(MyEntity_.name.equals('example')).build();
/// queryManager.setQuery(MyQueryType.nameQuery, query);
///
/// Retrieve a cached query
/// final myQuery = queryManager.getQuery(MyQueryType.nameQuery);
///
/// Close all queries
/// queryManager.closeAll();
/// ```
///
/// **Key Features**:
/// - Query Caching: Allows assigning and reusing queries using an [Enum] key.
/// - Query Retrieval: Fetches cached queries by their associated key.
/// - Resource Management: Provides a method to close all cached queries,
///   ensuring proper cleanup of resources.
///
/// **Note**: Make sure to call [closeAll] when the queries are no longer
/// needed to free up resources.
abstract class DaoQueryManager<T> {
  final Map<Enum, Query<T>> _queryCache = {};
  final Box<T> _box;

  DaoQueryManager(this._box);

  Box<T> get box => _box;

  Query<T>? getQuery(Enum queryType) => _queryCache[queryType];

  void setQuery(Enum queryType, Query<T> query) {
    _queryCache[queryType] = query;
  }

  bool hasQuery(Enum queryType) => _queryCache.containsKey(queryType);

  void closeAll() {
    for (final query in _queryCache.values) {
      query.close();
    }
    _queryCache.clear();
  }

  void closeQuery(Enum queryType) {
    final query = _queryCache[queryType];
    if (query != null) {
      query.close();
      _queryCache.remove(queryType);
    }
  }
}
