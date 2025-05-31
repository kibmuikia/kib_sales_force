import 'package:app_database/models/theme_mode_model.dart' show ThemeModeModel;
import 'package:app_database/objectbox.g.dart';

import 'base.dart';
import 'enums.dart';

class ThemeModeQueryManager extends DaoQueryManager<ThemeModeModel> {
  ThemeModeQueryManager(super.box);

  /// Returns a query to fetch the most recent ThemeModeModel.
  ///
  /// If the query is not already cached, a new query is created to get
  /// all ThemeModeModel entries ordered by createdAt in descending order,
  /// ensuring the most recent theme mode is returned first.
  ///
  /// - Returns: A `Query<ThemeModeModel>` instance configured for this filter.
  Query<ThemeModeModel> getMostRecentThemeModeQuery() {
    var query = getQuery(ThemeModeQueryType.mostRecent);
    if (query == null) {
      query = box
          .query()
          .order(ThemeModeModel_.createdAt, flags: Order.descending)
          .build();
      setQuery(ThemeModeQueryType.mostRecent, query);
    }
    return query;
  }

  /// Returns a query to fetch ThemeModeModel entries filtered by mode.
  ///
  /// If the query is not already cached, a new query is created to filter
  /// theme modes where the mode matches an empty string placeholder.
  ///
  /// - Returns: A `Query<ThemeModeModel>` instance configured for this filter.
  Query<ThemeModeModel> getByModeQuery() {
    var query = getQuery(ThemeModeQueryType.byMode);
    if (query == null) {
      query = box
          .query(ThemeModeModel_.mode.equals(''))
          .build();
      setQuery(ThemeModeQueryType.byMode, query);
    }
    return query;
  }

  /// Returns a query to fetch ThemeModeModel entries created after a specific date.
  ///
  /// If the query is not already cached, a new query is created to filter
  /// theme modes where the createdAt date is greater than a placeholder date.
  ///
  /// - Returns: A `Query<ThemeModeModel>` instance configured for this filter.
  Query<ThemeModeModel> getAfterDateQuery() {
    var query = getQuery(ThemeModeQueryType.afterDate);
    if (query == null) {
      final placeholderDate = DateTime.now();
      query = box
          .query(ThemeModeModel_.createdAt.greaterThan(placeholderDate.millisecondsSinceEpoch))
          .build();
      setQuery(ThemeModeQueryType.afterDate, query);
    }
    return query;
  }
}

