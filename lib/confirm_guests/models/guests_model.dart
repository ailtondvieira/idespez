// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GuestsModel {
  String? id;
  String name;
  String phone;
  bool isConfirm;

  GuestsModel({
    this.id,
    required this.name,
    required this.phone,
    required this.isConfirm,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'isConfirm': isConfirm,
    };
  }

  factory GuestsModel.fromMap(Map<String, dynamic> map) {
    return GuestsModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      isConfirm: map['isConfirm'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GuestsModel.fromJson(String source) =>
      GuestsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
