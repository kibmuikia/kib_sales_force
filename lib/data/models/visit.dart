import 'dart:convert' show jsonEncode;

import 'package:app_database/models/export.dart' show VisitEntity;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:json_annotation/json_annotation.dart'
    show JsonKey, JsonSerializable;
import 'package:kib_sales_force/core/constants/app_constants.dart'
    show defaultVisitLocation, defaultVisitNotes;
import 'package:kib_sales_force/core/utils/common_enum.dart'
    show StringVisitStatusExtension, VisitStatus;

part 'visit.g.dart';

@JsonSerializable()
class Visit extends Equatable {
  final int id;
  @JsonKey(name: 'customer_id')
  final int customerId;
  @JsonKey(name: 'visit_date')
  final DateTime visitDate;
  final String status;
  final String location;
  final String notes;
  @JsonKey(
      name: 'activities_done',
      fromJson: _activitiesFromJson,
      toJson: _activitiesToJson)
  final List<int> activitiesDone;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const Visit({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
  })  : assert(id >= 0, 'ID must be non-negative'),
        assert(customerId > 0, 'Customer ID must be positive'),
        assert(status != '', 'Status cannot be empty');

  @override
  List<Object?> get props => [
        id,
        customerId,
        visitDate,
        status,
        location,
        notes,
        activitiesDone,
        createdAt,
      ];

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);

  Map<String, dynamic> toJson() => _$VisitToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  Visit copyWith({
    int? id,
    int? customerId,
    DateTime? visitDate,
    String? status,
    String? location,
    String? notes,
    List<int>? activitiesDone,
    DateTime? createdAt,
  }) {
    return Visit(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      visitDate: visitDate ?? this.visitDate,
      status: status ?? this.status,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      activitiesDone: activitiesDone ?? this.activitiesDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Visit.create({
    required int customerId,
    required DateTime visitDate,
    required String location,
    String notes = '',
    List<int> activitiesDone = const [],
    String status = 'created',
  }) {
    return Visit(
      id: 0,
      customerId: customerId,
      visitDate: visitDate,
      status: status,
      location: location,
      notes: notes,
      activitiesDone: activitiesDone,
      createdAt: DateTime.now(),
    );
  }

  factory Visit.defaultVisit() {
    final now = DateTime.now();
    return Visit(
      id: 0,
      customerId: 0,
      visitDate: now,
      status: 'created',
      location: defaultVisitLocation,
      notes: defaultVisitNotes,
      activitiesDone: const [],
      createdAt: now,
    );
  }

  // Helper methods
  VisitStatus? get visitStatus => status.tryFromString();
  bool get isCompleted => visitStatus?.isCompleted ?? false;
  bool get isPending => visitStatus?.isPending ?? false;
  bool get isCancelled => visitStatus?.isCancelled ?? false;
  bool get isOngoing => visitStatus?.isOngoing ?? false;
  bool get isCreated => visitStatus?.isCreated ?? false;
  bool get hasActivities => activitiesDone.isNotEmpty;
  bool get isDefault =>
      id == 0 &&
      customerId == 0 &&
      location == defaultVisitLocation &&
      notes == defaultVisitNotes;
  int get activityCount => activitiesDone.length;

  static List<int> _activitiesFromJson(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json
          .map((e) {
            if (e is String) {
              return int.tryParse(e) ?? -1;
            } else if (e is int) {
              return e;
            }
            return -1;
          })
          .where((id) => id >= 0)
          .toList();
    }
    return [];
  }

  static List<String> _activitiesToJson(List<int> activities) {
    return activities.map((e) => e.toString()).toList();
  }

  bool get isOverdue => visitDate.isBefore(DateTime.now()) && !isCompleted && !isCancelled;
  bool get isUpcoming => visitDate.isAfter(DateTime.now()) && !isCompleted && !isCancelled;
  bool get isToday => visitDate.year == DateTime.now().year && 
                      visitDate.month == DateTime.now().month && 
                      visitDate.day == DateTime.now().day;

  // mappers
  VisitEntity toVisitEntity({required String userUid}) {
    return VisitEntity(
      autoId: 0,
      id: id,
      customerId: customerId,
      visitDate: visitDate, 
      status: status,
      location: location,
      notes: notes,
      activitiesDone: activitiesDone,
      createdAt: createdAt,
      userUid: userUid,
    );
  }

  static Visit fromVisitEntity(VisitEntity entity) {
    return Visit(
      id: entity.id,
      customerId: entity.customerId,
      visitDate: entity.visitDate,
      status: entity.status,
      location: entity.location,
      notes: entity.notes,
      activitiesDone: entity.activitiesDone,
      createdAt: entity.createdAt,
    );
  }
}

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
