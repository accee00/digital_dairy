// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.imageUrl,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id']?.toString(),
    name: map['full_name']?.toString() ?? '',
    email: map['email']?.toString() ?? '',
    phoneNumber: map['phone_number']?.toString() ?? '',
    imageUrl: map['image_url']?.toString(),
    createdAt:
        map['created_at'] != null && map['created_at'].toString().isNotEmpty
        ? DateTime.parse(map['created_at'].toString())
        : null,
    updatedAt:
        map['updated_at'] != null && map['updated_at'].toString().isNotEmpty
        ? DateTime.parse(map['updated_at'].toString())
        : null,
  );

  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    imageUrl: imageUrl ?? this.imageUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'image_url': imageUrl,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  }..removeWhere((key, value) => value == null);

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, phone: $phoneNumber, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  List<Object?> get props => <Object?>[id, email, imageUrl];
}
