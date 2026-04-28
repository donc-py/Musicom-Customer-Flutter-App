import 'dart:convert';

class Event {
  final int id;
  final String title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? location;
  final String? thumbnail;
  final bool isActive;

  Event({
    required this.id,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    required this.startsAt,
    this.endsAt,
    this.location,
    this.thumbnail,
    this.isActive = true,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String,
      titleAr: map['title_ar'] as String?,
      description: map['description'] as String?,
      descriptionAr: map['description_ar'] as String?,
      startsAt: DateTime.parse(map['starts_at'] as String),
      endsAt: map['ends_at'] != null
          ? DateTime.parse(map['ends_at'] as String)
          : null,
      location: map['location'] as String?,
      thumbnail: map['thumbnail'] as String?,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'title_ar': titleAr,
        'description': description,
        'description_ar': descriptionAr,
        'starts_at': startsAt.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
        'location': location,
        'thumbnail': thumbnail,
        'is_active': isActive,
      };

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Event(id: $id, title: $title, startsAt: $startsAt)';
}
