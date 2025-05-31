import 'package:app_database/models/model_ids.dart' show ModelId;
import 'package:objectbox/objectbox.dart';

/* 
* Sample Activity:
  {
    "id": 1,
    "description": "Discussed new product features.",
    "created_at": "2025-04-30T05:23:03.034139+00:00"
  }
*/

@Entity(uid: ModelId.activity)
class ActivityEntity {
  @Id()
  @Property(uid: 5053459731144723610)
  int autoId;

  @Property(uid: 8111402623661835611)
  int id;

  @Property(uid: 8544234466963278429)
  String description;

  @Property(type: PropertyType.date, uid: 4847536752488570866)
  DateTime createdAt;

  @Property(uid: 4591971185051021712)
  String userUid;

  ActivityEntity({
    required this.autoId,
    required this.id,
    required this.description,
    required this.createdAt,
    required this.userUid,
  });

  @override
  String toString() => 'ActivityEntity(id: $autoId, id: $id, description: $description, createdAt: $createdAt, userUid: $userUid)';
}
