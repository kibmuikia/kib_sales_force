import 'package:objectbox/objectbox.dart';

/// Base interface for all DAOs
abstract class BaseDao<T> {
  /// Get the box for this DAO
  Box<T> get box;

  /// Get an entity by id
  T? getById(int id) => box.get(id);

  /// Save an entity
  int put(T entity) => box.put(entity);

  /// Delete an entity
  bool delete(int id) => box.remove(id);

  /// Delete multiple entities
  int deleteMany(List<int> ids) => box.removeMany(ids);

  /// Delete all entities
  int deleteAll() => box.removeAll();

  /// Get all entities
  List<T> getAll() => box.getAll();

  /// Close resources if needed
  void close() {}
}
