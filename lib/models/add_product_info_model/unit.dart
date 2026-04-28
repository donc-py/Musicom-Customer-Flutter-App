import 'dart:convert';

class Unit {
  int? id;
  String? name;

  Unit({this.id, this.name});

  factory Unit.fromMap(Map<String, dynamic> data) => Unit(
        id: data['id'] as int?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Unit].
  factory Unit.fromJson(String data) {
    return Unit.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Unit] to a JSON string.
  String toJson() => json.encode(toMap());
}
