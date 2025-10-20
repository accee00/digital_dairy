import 'package:equatable/equatable.dart';

/// A class representing a buyer with properties to manage buyer information.
class Buyer extends Equatable {
  /// Constructs a constant `Buyer` object.
  const Buyer({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.contact,
    this.address,
  });

  /// Constructs a `Buyer` object from a JSON map.
  ///
  /// Requires a [json] map with keys corresponding to the properties of the `Buyer`.
  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    contact: json['contact'] as String?,
    address: json['address'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  /// Unique identifier for the buyer.
  final String id;

  /// User identifier associated with the buyer.
  final String userId;

  /// Name of the buyer.
  final String name;

  /// Contact information of the buyer, nullable.
  final String? contact;

  /// Address of the buyer, nullable.
  final String? address;

  /// Creation date and time of the buyer record.
  final DateTime createdAt;

  /// Converts a `Buyer` object into a JSON map.
  ///
  /// Returns a map with keys corresponding to the properties of the `Buyer`.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'user_id': userId,
    'name': name,
    'contact': contact,
    'address': address,
    'created_at': createdAt.toIso8601String(),
  };

  /// Creates a copy of this `Buyer` object but with overridden properties from optional parameters.
  ///
  /// Parameters are nullable and default to the current values if not provided.
  Buyer copyWith({
    String? id,
    String? userId,
    String? name,
    String? contact,
    String? address,
    DateTime? createdAt,
  }) => Buyer(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    address: address ?? this.address,
    createdAt: createdAt ?? this.createdAt,
  );

  /// List of properties used to determine whether two `Buyer` instances are equal.
  @override
  List<Object?> get props => <Object?>[
    id,
    userId,
    name,
    contact,
    address,
    createdAt,
  ];
}
