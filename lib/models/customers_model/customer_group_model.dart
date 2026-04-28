import 'dart:convert';

class CustomerGroupModel {
  int? id;
  String? name;
  double? dicountPercent;

  CustomerGroupModel({this.id, this.name, this.dicountPercent});

  factory CustomerGroupModel.fromMap(Map<String, dynamic> data) {
    return CustomerGroupModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
      dicountPercent: data['dicountPercent'] as double?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'dicountPercent': dicountPercent,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CustomerGroupModel].
  factory CustomerGroupModel.fromJson(String data) {
    return CustomerGroupModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CustomerGroupModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
