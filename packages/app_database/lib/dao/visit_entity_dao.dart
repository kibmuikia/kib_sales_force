import 'package:app_database/models/export.dart' show VisitEntity;
import 'package:app_database/objectbox.g.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'base.dart';

class VisitEntityDao extends BaseDao<VisitEntity> {
  VisitEntityDao(this._box);

  final Box<VisitEntity> _box;

  @override
  Box<VisitEntity> get box => _box;

  /// Get visit by id
  VisitEntity? getVisitById(int id) {
    try {
      final query = box.query(VisitEntity_.id.equals(id)).build();
      return query.findFirst();
    } on Exception catch (e) {
      debugPrint('** VisitEntityDao:getById: $e *');
      return null;
    }
  }

  /// Get all visits
  List<VisitEntity> getVisits() {
    try {
      final query = box.query()
        ..order(VisitEntity_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** VisitEntityDao:getAll: $e *');
      return [];
    }
  }

  /// Get all visits for a user
  List<VisitEntity> getVisitsForUser(String userId) {
    try {
      final query = box.query(VisitEntity_.userUid.equals(userId))
        ..order(VisitEntity_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** VisitEntityDao:getVisitsForUser: $e *');
      return [];
    }
  }

  /// Get visits by customer id
  List<VisitEntity> getVisitsByCustomerId(int customerId) {
    try {
      final query = box.query(VisitEntity_.customerId.equals(customerId))
        ..order(VisitEntity_.visitDate, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** VisitEntityDao:getVisitsByCustomerId: $e *');
      return [];
    }
  }

  /// Save or update visit
  /// Returns the ID of the saved/updated visit or -1 if operation failed
  int saveVisit(VisitEntity visit) {
    try {
      return put(visit);
    } on Exception catch (e) {
      debugPrint('** VisitEntityDao:save: $e *');
      return -1;
    }
  }

  /// Save or update multiple visits
  /// Returns the IDs of the saved visits or [] if operation failed
  List<int> saveManyVisits(List<VisitEntity> visits) {
    try {
      if (visits.isEmpty) {
        throw Exception('No visits to save');
      }
      return box.putMany(visits);
    } on Exception catch (e) {
      debugPrint('** VisitEntityDao:saveMany: $e *');
      return [];
    }
  }
}
