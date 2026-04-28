import 'dart:convert';

class Category {
  final int id;
  final String name;
  final String thumbnail;
  final List<Category> subCategories;
  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.subCategories = const [],
  });

  Category copyWith({
    int? id,
    String? name,
    String? thumbnail,
    List<Category>? subCategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'subCategories': subCategories,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      thumbnail: map['thumbnail'] as String,
      subCategories: (map['sub_categories'] as List<dynamic>?)
          ?.map((subCategory) => Category.fromMap(subCategory as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(id: $id, name: $name, thumbnail: $thumbnail, subCategories: $subCategories)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.thumbnail == thumbnail &&
        other.subCategories == subCategories;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thumbnail.hashCode ^
        subCategories.hashCode;
  }
}
