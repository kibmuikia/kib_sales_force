/// Enum defining the various types of queries for managing [ThemeModeModel] objects.
///
/// Available types:
/// - [mostRecent]: Retrieve the most recent ThemeModeModel ordered by createdAt.
/// - [byMode]: Retrieve ThemeModeModel entries by their mode value.
/// - [afterDate]: Retrieve ThemeModeModel entries created after a specific date.
enum ThemeModeQueryType {
  mostRecent,
  byMode,
  afterDate,
}
