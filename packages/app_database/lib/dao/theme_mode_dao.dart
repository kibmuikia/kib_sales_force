import 'package:app_database/dao/queryManager/theme_mode_dao_querymanager.dart'
    show ThemeModeQueryManager;
import 'package:app_database/objectbox.g.dart';
import 'package:app_database/models/export.dart' show ThemeModeModel;
import 'package:flutter/foundation.dart' show debugPrint;
import 'base.dart';

/// DAO for handling theme mode persistence
class ThemeModeDao extends BaseDao<ThemeModeModel> {
  /// Constructor
  ThemeModeDao(this._box) {
    _queryManager = ThemeModeQueryManager(_box);
  }

  final Box<ThemeModeModel> _box;
  late final ThemeModeQueryManager _queryManager;

  @override
  Box<ThemeModeModel> get box => _box;

  ThemeModeQueryManager get queryManager => _queryManager;

  @override
  void close() {
    _queryManager.closeAll();
    super.close();
  }

  /// Get the current theme mode
  ThemeModeModel? getCurrentThemeMode() {
    try {
      final query = _queryManager.getMostRecentThemeModeQuery();
      return query.findFirst();
    } on Exception catch (e) {
      debugPrint('** ThemeModeDao:getCurrentThemeMode: $e *');
      return null;
    }
  }

  /// Save a new theme mode
  int saveThemeMode(String mode) {
    try {
      final themeMode = ThemeModeModel(mode: mode);
      return put(themeMode);
    } on Exception catch (e) {
      debugPrint('** ThemeModeDao:saveThemeMode: $e *');
      return -1;
    }
  }

  /// Get theme modes matching the specified mode
  List<ThemeModeModel> getThemesModesByMode(String mode) {
    try {
      final query = _queryManager.getByModeQuery();
      query.param(ThemeModeModel_.mode).value = mode;
      return query.find();
    } on Exception catch (e) {
      debugPrint('** ThemeModeDao:getThemesModesByMode: $e *');
      return [];
    }
  }
}
