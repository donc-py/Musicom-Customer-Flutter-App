import 'dart:convert';

class WarehouseModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? totalPurchages;
  String? address;

  WarehouseModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.totalPurchages,
    this.address,
  });

  factory WarehouseModel.fromMap(Map<String, dynamic> data) {
    return WarehouseModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      totalPurchages: data['total_purchages'] as int?,
      address: data['address'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'total_purchages': totalPurchages,
        'address': address,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WarehouseModel].
  factory WarehouseModel.fromJson(String data) {
    return WarehouseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WarehouseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
