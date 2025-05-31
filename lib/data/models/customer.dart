import 'dart:convert' show jsonEncode;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kib_sales_force/core/constants/app_constants.dart'
    show defaultCustomerName;

part 'customer.g.dart';

@JsonSerializable()
class Customer extends Equatable {
  final int id;
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    required this.createdAt,
  })  : assert(id >= 0, 'ID must be non-negative'),
        assert(name != '', 'Name cannot be empty');

  @override
  List<Object?> get props => [id, name, createdAt];

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  Customer copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Customer.defaultCustomer() {
    return Customer(
      id: 0,
      name: defaultCustomerName,
      createdAt: DateTime.now(),
    );
  }

  bool get isValid => id >= 0 && name.trim().isNotEmpty;
  bool get isDefault => id == 0 && name == defaultCustomerName;
}

/* 
* Sample Customer:
  {
    "id": 1,
    "name": "John Doe",
    "created_at": "2025-04-30T05:23:03.034139+00:00"
  }
*/
