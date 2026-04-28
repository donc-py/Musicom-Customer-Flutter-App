import 'dart:convert';

class AddWarehouseModel {
  final String name;
  final String phone;
  final String address;
  final String email;
  AddWarehouseModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
    };
  }

  factory AddWarehouseModel.fromMap(Map<String, dynamic> map) {
    return AddWarehouseModel(
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddWarehouseModel.fromJson(String source) =>
      AddWarehouseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
