import 'dart:convert';

class Customer {
  dynamic id;
  dynamic name;
  dynamic phone;

  Customer({this.id, this.name, this.phone});

  factory Customer.fromMap(Map<String, dynamic> data) => Customer(
        id: data['id'] as dynamic,
        name: data['name'] as dynamic,
        phone: data['phone'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Customer].
  factory Customer.fromJson(String data) {
    return Customer.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Customer] to a JSON string.
  String toJson() => json.encode(toMap());
}
