import 'package:app_database/models/model_ids.dart' show ModelId;
import 'package:objectbox/objectbox.dart';

@Entity(uid: ModelId.themeMode)
class ThemeModeModel {
  @Id()
  @Property(uid: 8608593761304787301)
  int autoId;

  /// The theme mode: 'light', 'dark', or 'system'
  @Property(uid: 917518401460075336)
  String mode;

  /// When this theme mode was set
  @Property(type: PropertyType.date, uid: 4194516950331066119)
  DateTime createdAt;

  ThemeModeModel({
    this.autoId = 0,
    required this.mode,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() => 'ThemeModeModel(id: $autoId, mode: $mode, createdAt: $createdAt)';
}
