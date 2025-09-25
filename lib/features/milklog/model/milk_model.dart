// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MilkModel extends Equatable {
  final String? id;
  final String? userId;
  final String cattleId;
  final DateTime date;
  final ShiftType shift;
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
    'shift': shift.value,
    'quantity_litres': quantityInLiter,
    'notes': notes,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  }..removeWhere((String key, dynamic value) => value == null);

  factory MilkModel.fromMap(Map<String, dynamic> map) => MilkModel(
    id: map['id'] != null ? map['id'] as String : null,
    userId: map['user_id'] != null ? map['user_id'] as String : null,
    cattleId: map['cattle_id'] as String,
    date: DateTime.parse(map['date'] as String),
    shift: ShiftTypeValue.from('Morning'),
    quantityInLiter: map['quantity_litres'] as double,
    notes: map['notes'] as String,
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.parse(map['updated_at'] as String)
        : null,
  );

  MilkModel copyWith({
    String? id,
    String? userId,
    String? cattleId,
    DateTime? date,
    ShiftType? shift,
    double? quantityInLiter,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MilkModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cattleId: cattleId ?? this.cattleId,
    date: date ?? this.date,
    shift: shift ?? this.shift,
    quantityInLiter: quantityInLiter ?? this.quantityInLiter,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
