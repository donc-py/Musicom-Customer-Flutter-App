import 'dart:convert';

class CustomerModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? companyName;
  String? address;
  Group? group;

  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.companyName,
    this.address,
    this.group,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> data) => CustomerModel(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        companyName: data['company_name'] as String?,
        address: data['address'] as String?,
        group: data['group'] != null
            ? Group.fromMap(data['group'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'company_name': companyName,
        'address': address,
        'group': group?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CustomerModel].
  factory CustomerModel.fromJson(String data) {
    return CustomerModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CustomerModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

class Group {
  int? id;
  String? name;
  double? dicountPercent;

  Group({this.id, this.name, this.dicountPercent});

  factory Group.fromMap(Map<String, dynamic> data) => Group(
        id: data['id'] as int?,
        name: data['name'] as String?,
        dicountPercent: data['dicountPercent'] as double?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'dicountPercent': dicountPercent,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Group].
  factory Group.fromJson(String data) {
    return Group.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Group] to a JSON string.
  String toJson() => json.encode(toMap());
}
