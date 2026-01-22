// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:equatable/equatable.dart';

/// A model representing the details of milk production for a specific cattle at a specific time.
class MilkModel extends Equatable {
  /// Constructor for creating a new MilkModel instance.
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
    this.cattle,
  });

  /// Creates a MilkModel instance from a map.
  factory MilkModel.fromMap(Map<String, dynamic> map) => MilkModel(
    id: map['id'] != null ? map['id'] as String : null,
    userId: map['user_id'] != null ? map['user_id'] as String : null,
    cattleId: map['cattle_id'] as String,
    date: DateTime.parse(map['date'] as String),
    shift: ShiftType.from(map['shift'] as String),
    quantityInLiter: map['quantity_litres'] as double,
    notes: map['notes'] as String,
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.parse(map['updated_at'] as String)
        : null,
    cattle: map['cattle'] != null
        ? CattleData.fromMap(map['cattle'] as Map<String, dynamic>)
        : null,
  );

  /// Unique identifier for the milk record.
  final String? id;

  /// User identifier who logged the milk record.
  final String? userId;

  /// Identifier of the cattle that produced the milk.
  final String cattleId;

  /// Date when the milk was produced.
  final DateTime date;

  /// Shift during which the milk was produced (Morning/Evening).
  final ShiftType shift;

  /// Quantity of milk produced in liters.
  final double quantityInLiter;

  /// Additional notes regarding the milk production.
  final String notes;

  /// Timestamp when the record was created.
  final DateTime? createdAt;

  /// Timestamp when the record was last updated.
  final DateTime? updatedAt;

  /// Cattle information associated with this milk record.
  final CattleData? cattle;

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
    cattle,
  ];

  /// Converts the MilkModel instance into a map.
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

  /// Returns a new MilkModel instance with updated fields, allowing for immutability.
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
    CattleData? cattle,
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
    cattle: cattle ?? this.cattle,
  );
}

class CattleData extends Equatable {
  final String id;
  final String name;
  final String tagId;
  final String breed;
  final String imageUrl;

  const CattleData({
    required this.id,
    required this.name,
    required this.tagId,
    required this.breed,
    required this.imageUrl,
  });
  factory CattleData.fromMap(Map<String, dynamic> map) => CattleData(
    id: map['id'].toString(),
    name: map['name'].toString(),
    tagId: map['tag_id'].toString(),
    breed: map['breed'].toString(),
    imageUrl: map['image_url'].toString(),
  );
  @override
  List<Object?> get props => <Object?>[id, name, tagId, breed, imageUrl];
}
