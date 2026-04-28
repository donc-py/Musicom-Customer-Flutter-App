import 'dart:convert';

class Warehouse {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final int? totalPurchages;
  final String? address;

  Warehouse({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.totalPurchages,
    this.address,
  });

  Warehouse copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? totalPurchages,
    String? address,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      totalPurchages: totalPurchages ?? this.totalPurchages,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'total_purchages': totalPurchages,
      'address': address,
    };
  }

  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      id: map['id'].toInt(),
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      totalPurchages: map['total_purchages'] as int?,
      address: map['address'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Warehouse.fromJson(String source) =>
      Warehouse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Warehouse(id: $id, name: $name, email: $email, phone: $phone, totalPurchages: $totalPurchages, address: $address)';
  }

  @override
  bool operator ==(covariant Warehouse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.totalPurchages == totalPurchages &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        totalPurchages.hashCode ^
        address.hashCode;
  }
}
