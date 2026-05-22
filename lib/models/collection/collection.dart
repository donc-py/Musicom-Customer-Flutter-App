import 'dart:convert';

class Collection {
  final int id;
  final String name;
  final String? description; // ← campo nuevo, nullable
  final String thumbnail;

  Collection({
    required this.id,
    required this.name,
    this.description,
    required this.thumbnail,
  });

  Collection copyWith({
    int? id,
    String? name,
    String? description,
    String? thumbnail,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: (map['id'] as num).toInt(),
      name: map['name'] as String,
      description:
          map['description'] as String?, // null si el CMS no lo tiene aún
      thumbnail: map['thumbnail'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) =>
      Collection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Collection(id: $id, name: $name, description: $description, thumbnail: $thumbnail)';
  }

  @override
  bool operator ==(covariant Collection other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ thumbnail.hashCode;
}
