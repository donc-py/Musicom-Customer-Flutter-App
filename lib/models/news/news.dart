import 'dart:convert';

class News {
  final int id;
  final String title;
  final String? titleAr;
  final String? excerpt;
  final String? excerptAr;
  final String? body;
  final String? bodyAr;
  final String? category;
  final DateTime? publishedAt;
  final String? thumbnail;
  final bool isActive;

  News({
    required this.id,
    required this.title,
    this.titleAr,
    this.excerpt,
    this.excerptAr,
    this.body,
    this.bodyAr,
    this.category,
    this.publishedAt,
    this.thumbnail,
    this.isActive = true,
  });

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String,
      titleAr: map['title_ar'] as String?,
      excerpt: map['excerpt'] as String?,
      excerptAr: map['excerpt_ar'] as String?,
      body: map['body'] as String?,
      bodyAr: map['body_ar'] as String?,
      category: map['category'] as String?,
      publishedAt: map['published_at'] != null
          ? DateTime.parse(map['published_at'] as String)
          : null,
      thumbnail: map['thumbnail'] as String?,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'title_ar': titleAr,
        'excerpt': excerpt,
        'excerpt_ar': excerptAr,
        'body': body,
        'body_ar': bodyAr,
        'category': category,
        'published_at': publishedAt?.toIso8601String(),
        'thumbnail': thumbnail,
        'is_active': isActive,
      };

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) =>
      News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'News(id: $id, title: $title, category: $category)';
}
