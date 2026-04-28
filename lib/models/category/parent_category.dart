import 'dart:convert';

class ParentCategory {
  final int id;
  final String name;
  ParentCategory({
    required this.id,
    required this.name,
  });

  ParentCategory copyWith({
    int? id,
    String? name,
  }) {
    return ParentCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory ParentCategory.fromMap(Map<String, dynamic> map) {
    return ParentCategory(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParentCategory.fromJson(String source) =>
      ParentCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ParentCategory(id: $id, name: $name)';

  @override
  bool operator ==(covariant ParentCategory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
