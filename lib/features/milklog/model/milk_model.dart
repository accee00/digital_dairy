// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MilkModel extends Equatable {
  final String? id;
  final String? userId;
  final String cattleId;
  final DateTime date;
  final String shift;
  final double quantityInLiter;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const MilkModel({
    required this.cattleId,

    required this.date,
    required this.shift,
    required this.quantityInLiter,
    required this.notes,
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => <Object?>[
    id,
    userId,
    cattleId,
    date,
    shift,
    quantityInLiter,
    notes,
    createdAt,
    updatedAt,
  ];

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'user_id': userId,
    'cattle_id': cattleId,
    'date': date.toIso8601String().split('T').first,
    'shift': shift,
    'quantity_litres': quantityInLiter,
    'notes': notes,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  }..removeWhere((String key, dynamic value) => value == null);

  factory MilkModel.fromMap(Map<String, dynamic> map) => MilkModel(
    id: map['id'] != null ? map['id'] as String : null,
    userId: map['userId'] != null ? map['userId'] as String : null,
    cattleId: map['cattleId'] as String,
    date: DateTime.parse(map['date'] as String),
    shift: map['shift'] as String,
    quantityInLiter: map['quantityInLiter'] as double,
    notes: map['notes'] as String,
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.parse(map['updated_at'] as String)
        : null,
  );

  String toJson() => json.encode(toMap());

  factory MilkModel.fromJson(String source) =>
      MilkModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
