import 'package:equatable/equatable.dart';

/// Represents a Cattle entity with various attributes related to cattle management.
///
/// This class extends [Equatable] to provide value equality based on the
/// [tagId] and [id] properties. It contains information such as the cattle's
/// user ID, name, tag ID, image URL, breed, gender, date of birth, calving
/// date, status, notes, and timestamps for creation and updates.
class Cattle extends Equatable {
  /// Creates a new instance of [Cattle].
  ///
  /// The [userId], [name], [tagId], [imageUrl], [breed], [gender], [dob],
  /// [calvingDate], [status], and [notes] parameters are required.
  const Cattle({
    required this.userId,
    required this.name,
    required this.tagId,
    required this.breed,
    required this.gender,
    required this.status,
    required this.notes,
    this.imageUrl,
    this.dob,
    this.calvingDate,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a [Cattle] instance from a map.
  ///
  /// This factory constructor is used to deserialize a map object into a [Cattle] instance.
  factory Cattle.fromMap(Map<String, dynamic> map) => Cattle(
    id: map['id'] as String,
    userId: map['user_id'] as String,
    name: map['name'] as String,
    tagId: map['tag_id'] as String,
    imageUrl: map['image_url']?.toString(),
    breed: map['breed'] as String,
    gender: map['gender'] as String,
    dob: map['dob'] != null ? DateTime.parse(map['dob'] as String) : null,
    calvingDate: map['calving_date'] != null
        ? DateTime.parse(map['calving_date'] as String)
        : null,
    status: map['status'] as String,
    notes: map['notes'] as String,
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.parse(map['updated_at'] as String)
        : null,
  );

  /// The unique identifier for the cattle (optional).
  final String? id;

  /// The unique identifier of the user who owns the cattle.
  final String userId;

  /// The name of the cattle.
  final String name;

  /// The tag identifier for the cattle.
  final String tagId;

  /// The URL of the cattle's image.
  final String? imageUrl;

  /// The breed of the cattle.
  final String breed;

  /// The gender of the cattle.
  final String gender;

  /// The date of birth of the cattle.
  final DateTime? dob;

  /// The expected calving date of the cattle.
  final DateTime? calvingDate;

  /// The current status of the cattle (e.g., active, inactive).
  final String status;

  /// Additional notes related to the cattle.
  final String notes;

  /// The timestamp when the cattle record was created (optional).
  final DateTime? createdAt;

  /// The timestamp when the cattle record was last updated (optional).
  final DateTime? updatedAt;

  @override
  List<Object?> get props => <Object?>[tagId, id];

  /// Creates a copy of the current [Cattle] instance with the option to
  /// override specific fields.
  ///
  /// If a field is not provided, the current value will be retained.
  Cattle copyWith({
    String? id,
    String? userId,
    String? name,
    String? tagId,
    String? imageUrl,
    String? breed,
    String? gender,
    DateTime? dob,
    DateTime? calvingDate,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Cattle(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    tagId: tagId ?? this.tagId,
    imageUrl: imageUrl ?? this.imageUrl,
    breed: breed ?? this.breed,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    calvingDate: calvingDate ?? this.calvingDate,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Converts the [Cattle] instance into a map for insertion into a database.
  ///
  /// This method is used to serialize the [Cattle] instance into a map, excluding null values.
  Map<String, dynamic> tojsonForInsert() => <String, dynamic>{
    'user_id': userId,
    'name': name,
    'tag_id': tagId,
    'image_url': imageUrl,
    'breed': breed,
    'gender': gender,
    'dob': dob?.toIso8601String().split('T').first,
    'calving_date': calvingDate?.toIso8601String().split('T').first,
    'status': status,
    'notes': notes,
    'created_at': createdAt?.toIso8601String(),
  }..removeWhere((String key, dynamic value) => value == null);

  /// Converts the [Cattle] instance into a map for updating a database record.
  ///
  /// This method is used to serialize the [Cattle] instance into a map, including the 'updated_at' field.
  Map<String, dynamic> tojsonForUpdate() => <String, dynamic>{
    'id': id,
    'user_id': userId,
    'name': name,
    'tag_id': tagId,
    'image_url': imageUrl,
    'breed': breed,
    'gender': gender,
    'dob': dob?.toIso8601String().split('T').first,
    'calving_date': calvingDate?.toIso8601String().split('T').first,
    'status': status,
    'notes': notes,
    'updated_at': createdAt?.toIso8601String(),
  };

  @override
  String toString() =>
      'Cattle('
      'id: $id, '
      'userId: $userId, '
      'name: $name, '
      'tagId: $tagId, '
      'imageUrl: $imageUrl, '
      'breed: $breed, '
      'gender: $gender, '
      'dob: $dob, '
      'calvingDate: $calvingDate, '
      'status: $status, '
      'notes: $notes, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt'
      ')';

  @override
  bool get stringify => true;
}
