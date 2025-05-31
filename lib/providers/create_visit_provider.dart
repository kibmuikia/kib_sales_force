import 'package:flutter/material.dart';
import 'package:kib_sales_force/core/utils/export.dart' show GeneralStatus;
import 'package:kib_sales_force/data/models/export.dart' show Customer, Visit;
import 'package:kib_sales_force/services/export.dart'
    show CustomersService, VisitsService;
import 'package:kib_utils/kib_utils.dart';

class CreateVisitProvider extends ChangeNotifier {
  final VisitsService _visitsService;
  final CustomersService _customersService;
  GeneralStatus _status = GeneralStatus.initial;
  String? _errorMessage;
  List<Customer> _customers = [];
  int _selectedCustomerId = -1;

  CreateVisitProvider({
    required VisitsService visitsService,
    required CustomersService customersService,
  })  : _visitsService = visitsService,
        _customersService = customersService;

  GeneralStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Customer> get customers => _customers;
  int get selectedCustomerId => _selectedCustomerId;

  void init() {
    if (!_status.isLoading) {
      _customersService.streamCustomers().listen((customers) {
        _customers = customers;
        notifyListeners();
      }, onError: (error, stackTrace) {
        _errorMessage = error.toString();
        _status = GeneralStatus.error;
        notifyListeners();
      }, onDone: () {
        _status = GeneralStatus.loaded;
        notifyListeners();
      });
    }
  }

  void updateErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void updateSelectedCustomerId(int customerId) {
    _selectedCustomerId = customerId;
    notifyListeners();
  }

  Future<bool> saveVisit(Visit visit) async {
    _errorMessage = null;
    _status = GeneralStatus.loading;
    notifyListeners();

    try {
      final result = await _visitsService.saveVisit(visit);
      _status = GeneralStatus.loaded;
      notifyListeners();
      switch (result) {
        case Success(value: final value):
          if (value) {
            return true;
          }
          _errorMessage = 'Failed to save visit';
          _status = GeneralStatus.error;
          notifyListeners();
          return false;
        case Failure(error: final error):
          _errorMessage = error.toString();
          _status = GeneralStatus.error;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = GeneralStatus.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _errorMessage = null;
    _status = GeneralStatus.initial;
    notifyListeners();
  }
}
