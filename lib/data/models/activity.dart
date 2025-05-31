import 'dart:convert' show jsonEncode;

import 'package:app_database/models/export.dart' show ActivityEntity;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kib_sales_force/core/constants/app_constants.dart'
    show defaultActivityDescription;

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Equatable {
  final int id;
  final String description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const Activity({
    required this.id,
    required this.description,
    required this.createdAt,
  })  : assert(id >= 0, 'ID must be non-negative'),
        assert(description != '', 'Description cannot be empty');

  @override
  List<Object?> get props => [id, description, createdAt];

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  Activity copyWith({
    int? id,
    String? description,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Activity.defaultActivity() {
    return Activity(
      id: 0,
      description: defaultActivityDescription,
      createdAt: DateTime.now(),
    );
  }

  bool get isValid => id >= 0 && description.trim().isNotEmpty;
  bool get isDefault => id == 0 && description == defaultActivityDescription;

  // mappers
  ActivityEntity toEntity(String userUid) => ActivityEntity(
        id: id,
        description: description,
        createdAt: createdAt,
        autoId: 0,
        userUid: userUid,
      );

  static Activity fromEntity(ActivityEntity entity) => Activity(
        id: entity.id,
        description: entity.description,
        createdAt: entity.createdAt,
      );
}

/* 
* Sample Activity:
  {
    "id": 1,
    "description": "Discussed new product features.",
    "created_at": "2025-04-30T05:23:03.034139+00:00"
  }
*/
