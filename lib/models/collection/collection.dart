import 'dart:convert';

class Collection {
  final int id;
  final String name;
  final String thumbnail;
  Collection({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  Collection copyWith({
    int? id,
    String? name,
    String? thumbnail,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      thumbnail: map['thumbnail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) =>
      Collection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Collection(id: $id, name: $name, thumbnail: $thumbnail)';
  }

  @override
  bool operator ==(covariant Collection other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thumbnail.hashCode;
  }
}
