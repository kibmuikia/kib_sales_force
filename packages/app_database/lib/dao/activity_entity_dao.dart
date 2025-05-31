import 'package:app_database/models/export.dart' show ActivityEntity;
import 'package:app_database/objectbox.g.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'base.dart';

class ActivityEntityDao extends BaseDao<ActivityEntity> {
  ActivityEntityDao(this._box);

  final Box<ActivityEntity> _box;

  @override
  Box<ActivityEntity> get box => _box;

  /// Get activity by id
  ActivityEntity? getActivityById(int id) {
    try {
      final query = box.query(ActivityEntity_.id.equals(id)).build();
      return query.findFirst();
    } on Exception catch (e) {
      debugPrint('** ActivityEntityDao:getById: $e *');
      return null;
    }
  }

  /// Get all activities
  List<ActivityEntity> getActivities() {
    try {
      final query = box.query()
        ..order(ActivityEntity_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** ActivityEntityDao:getAll: $e *');
      return [];
    }
  }

  /// Get all activities for a user
  List<ActivityEntity> getActivitiesForUser(String userId) {
    try {
      final query = box.query(ActivityEntity_.userUid.equals(userId))
        ..order(ActivityEntity_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** ActivityEntityDao:getActivitiesForUser: $e *');
      return [];
    }
  }

  /// Save or update activity
  /// Returns the ID of the saved/updated activity or -1 if operation failed
  int saveActivity(ActivityEntity activity) {
    try {
      return put(activity);
    } on Exception catch (e) {
      debugPrint('** ActivityEntityDao:save: $e *');
      return -1;
    }
  }
}
