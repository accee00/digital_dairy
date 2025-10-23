import 'package:equatable/equatable.dart';

/// Represents a sale of milk with detailed transaction information.
class MilkSale extends Equatable {
  /// Constructs a constant MilkSale instance.
  const MilkSale({
    required this.buyerId,
    required this.date,
    required this.quantityLitres,
    required this.pricePerLitre,
    required this.createdAt,
    this.id,
    this.userId,
    this.totalAmount,
    this.notes,
  });

  /// Creates a MilkSale instance from a JSON map.
  factory MilkSale.fromJson(Map<String, dynamic> json) => MilkSale(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    buyerId: json['buyer_id'] as String,
    date: DateTime.parse(json['date'] as String),
    quantityLitres: (json['quantity_litres'] as num).toDouble(),
    pricePerLitre: (json['price_per_litre'] as num).toDouble(),
    totalAmount: json['total_amount'] != null
        ? (json['total_amount'] as num).toDouble()
        : null,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  /// Unique identifier for the milk sale.
  final String? id;

  /// User ID of the seller.
  final String? userId;

  /// Buyer ID of the purchaser.
  final String buyerId;

  /// Date of the milk sale.
  final DateTime date;

  /// Quantity of milk sold in litres.
  final double quantityLitres;

  /// Price per litre of milk.
  final double pricePerLitre;

  /// Total amount of the sale.
  final double? totalAmount;

  /// Optional notes about the sale.
  final String? notes;

  /// Timestamp when the sale record was created.
  final DateTime createdAt;

  /// Converts a MilkSale instance to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'user_id': userId,
    'buyer_id': buyerId,
    'date': date.toIso8601String(),
    'quantity_litres': quantityLitres,
    'price_per_litre': pricePerLitre,
    'total_amount': totalAmount,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
  }..removeWhere((String key, dynamic value) => value == null);

  /// Returns a new MilkSale instance replacing any provided optional values.
  MilkSale copyWith({
    String? id,
    String? userId,
    String? buyerId,
    DateTime? date,
    double? quantityLitres,
    double? pricePerLitre,
    double? totalAmount,
    String? notes,
    DateTime? createdAt,
  }) => MilkSale(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    buyerId: buyerId ?? this.buyerId,
    date: date ?? this.date,
    quantityLitres: quantityLitres ?? this.quantityLitres,
    pricePerLitre: pricePerLitre ?? this.pricePerLitre,
    totalAmount: totalAmount ?? this.totalAmount,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
  );

  /// List of properties considered in whether two instances are equivalent.
  @override
  List<Object?> get props => <Object?>[
    id,
    userId,
    buyerId,
    date,
    quantityLitres,
    pricePerLitre,
    totalAmount,
    notes,
    createdAt,
  ];
}
