import 'package:app_database/models/export.dart' show CustomerEntity;
import 'package:app_database/objectbox.g.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'base.dart';

class CustomerEntityDao extends BaseDao<CustomerEntity> {
  CustomerEntityDao(this._box);

  final Box<CustomerEntity> _box;

  @override
  Box<CustomerEntity> get box => _box;

  /// Get customer by id
  CustomerEntity? getCustomerById(int id) {
    try {
      final query = box.query(CustomerEntity_.id.equals(id)).build();
      return query.findFirst();
    } on Exception catch (e) {
      debugPrint('** CustomerEntityDao:getById: $e *');
      return null;
    }
  }

  /// Get all customers
  List<CustomerEntity> getCustomers() {
    try {
      final query = box.query()
        ..order(CustomerEntity_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** CustomerEntityDao:getAll: $e *');
      return [];
    }
  }

  /// Get all customers for a user
  List<CustomerEntity> getCustomersForUser(String userId) {
    try {
      final query = box.query(CustomerEntity_.userUid.equals(userId))
        ..order(CustomerEntity_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** CustomerEntityDao:getCustomersForUser: $e *');
      return [];
    }
  }

  /// Save or update customer
  /// Returns the ID of the saved/updated customer or -1 if operation failed
  int saveCustomer(CustomerEntity customer) {
    try {
      return put(customer);
    } on Exception catch (e) {
      debugPrint('** CustomerEntityDao:save: $e *');
      return -1;
    }
  }
}
