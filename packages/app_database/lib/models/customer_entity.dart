import 'package:app_database/models/model_ids.dart' show ModelId;
import 'package:objectbox/objectbox.dart';

/* 
* Sample Customer:
  {
    "id": 1,
    "name": "John Doe",
    "created_at": "2025-04-30T05:23:03.034139+00:00"
  }
*/

@Entity(uid: ModelId.customer)
class CustomerEntity {
  @Id()
  @Property(uid: 2156686820265552436)
  int autoId;

  @Property(uid: 3451847593037743476)
  int id;

  @Property(uid: 4575968678986614546)
  String name;

  @Property(type: PropertyType.date, uid: 4494686912394081775)
  DateTime createdAt;

  @Property(uid: 4781502931258714917)
  String userUid;

  CustomerEntity({
    required this.autoId,
    required this.id,
    required this.name,
    required this.createdAt,
    required this.userUid,
  });

  @override
  String toString() =>
      'CustomerEntity(id: $autoId, id: $id, name: $name, createdAt: $createdAt, userUuid: $userUid)';
}
