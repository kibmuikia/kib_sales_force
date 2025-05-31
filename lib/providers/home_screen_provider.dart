import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart' show ChangeNotifier;
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
  StreamSubscription<List<Visit>>? _visitsSubscription;

  GeneralStatus get status => _status;
  Object? get error => _error;
  String? get errorToString => _error?.toString();
  List<Visit> get visits => _visits;

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
        _visits = entries;
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

  //
}
