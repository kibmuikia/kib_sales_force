import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:kib_sales_force/core/utils/common_enum.dart'
    show VisitStatus, StringVisitStatusExtension;
import 'package:kib_sales_force/core/utils/export.dart' show GeneralStatus;
import 'package:kib_sales_force/data/models/visit.dart';
import 'package:kib_sales_force/di/setup.dart' show getIt;
import 'package:kib_sales_force/services/export.dart'
    show ActivitiesService, CustomersService, VisitsService;

class HomeScreenProvider extends ChangeNotifier {
  late final VisitsService _visitsService;
  late final CustomersService _customersService;
  late final ActivitiesService _activitiesService;

  HomeScreenProvider() {
    _visitsService = getIt<VisitsService>();
    _customersService = getIt<CustomersService>();
    _activitiesService = getIt<ActivitiesService>();
  }

  GeneralStatus _status = GeneralStatus.initial;
  Object? _error;
  List<Visit> _visits = [];
  List<Visit> _allVisits = [];
  StreamSubscription<List<Visit>>? _visitsSubscription;

  // Search & filter state
  String _searchQuery = '';
  VisitStatus? _statusFilter;

  GeneralStatus get status => _status;
  Object? get error => _error;
  String? get errorToString => _error?.toString();
  List<Visit> get visits => _visits;
  String get searchQuery => _searchQuery;
  VisitStatus? get statusFilter => _statusFilter;

  Future<void> init() async {
    if (!_status.isLoading) {
      setupVisitsStream();
    }
  }

  void setStatus(GeneralStatus status) {
    _status = status;
    notifyListeners();
  }

  void setError(Object? error) {
    _error = error;
    notifyListeners();
  }

  void setupVisitsStream() {
    _visitsSubscription?.cancel();
    _visitsSubscription = _visitsService.streamVisits().listen(
      (entries) {
        _allVisits = entries;
        _applySearchAndFilter();
        _status = GeneralStatus.loaded;
        notifyListeners();
      },
      onError: (error) {
        _status = GeneralStatus.error;
        _error = error;
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applySearchAndFilter();
    notifyListeners();
  }

  void setStatusFilter(VisitStatus? status) {
    _statusFilter = status;
    _applySearchAndFilter();
    notifyListeners();
  }

  void _applySearchAndFilter() {
    List<Visit> filtered = List.from(_allVisits);
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((v) =>
              v.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_statusFilter != null) {
      filtered = filtered
          .where((v) => v.status.tryFromString() == _statusFilter)
          .toList();
    }
    _visits = filtered;
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _applySearchAndFilter();
    notifyListeners();
  }

  //
}
