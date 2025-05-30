import 'dart:convert' show jsonEncode;

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
  })  : assert(id > 0, 'ID must be positive'),
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

  bool get isValid => id > 0 && description.isNotEmpty;
}
