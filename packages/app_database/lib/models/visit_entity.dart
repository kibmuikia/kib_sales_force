import 'package:app_database/models/model_ids.dart' show ModelId;
import 'package:objectbox/objectbox.dart';

/* 
* Sample Visit:
  {
    "id": 11,
    "customer_id": 1,
    "visit_date": "2023-10-01T10:00:00+00:00",
    "status": "Completed",
    "location": "123 Main St, Springfield",
    "notes": "Discussed new product features.",
    "activities_done": ["1", "2"],
    "created_at": "2025-04-30T05:23:03.034139+00:00"
  }
*/

@Entity(uid: ModelId.visit)
class VisitEntity {
  @Id()
  @Property(uid: 6260072064934754984)
  int autoId;

  @Property(uid: 6685238960465542205)
  int id;

  @Property(uid: 7695257420417939459)
  int customerId;

  @Property(type: PropertyType.date, uid: 5334846657945591573)
  DateTime visitDate;

  @Property(uid: 1583449531753570414)
  String status;

  @Property(uid: 4585427820610109330)
  String location;

  @Property(uid: 89618658098646128)
  String notes;

  @Property(uid: 719525743937912672)
  List<int> activitiesDone;

  @Property(type: PropertyType.date, uid: 2890993545212095641)
  DateTime createdAt;

  @Property(uid: 6272140009408727234)
  String userUid;

  VisitEntity({
    required this.autoId,
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
    required this.userUid,
  });

  @override
  String toString() =>
      'VisitEntity(id: $autoId, id: $id, customerId: $customerId, visitDate: $visitDate, status: $status, location: $location, notes: $notes, activitiesDone: $activitiesDone, createdAt: $createdAt, userUid: $userUid)';
}
