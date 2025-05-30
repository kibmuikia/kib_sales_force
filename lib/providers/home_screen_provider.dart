import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:kib_sales_force/core/utils/export.dart' show GeneralStatus;

class HomeScreenProvider extends ChangeNotifier {
  GeneralStatus _status = GeneralStatus.initial;
  Object? _error;
  List<dynamic> _entries = []; // TODO: to implement

  GeneralStatus get status => _status;
  Object? get error => _error;
  String? get errorToString => _error?.toString();
  List<dynamic> get entries => _entries;

  Future<void> init() async {
    if (!_status.isLoading) {
      // TODO: to implement
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

  //
}
