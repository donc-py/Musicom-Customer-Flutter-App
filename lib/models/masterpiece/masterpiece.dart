import 'dart:convert';

class Masterpiece {
  final int id;
  final String title;
  final String? titleAr;
  final int? year;
  final String? shortDescription;
  final String? longDescription;
  final String? thumbnail;
  final String? qrCode;
  final int? brandId;
  final String? brandName;
  final int? collectionId;
  final String? collectionName;
  final bool isActive;

  Masterpiece({
    required this.id,
    required this.title,
    this.titleAr,
    this.year,
    this.shortDescription,
    this.longDescription,
    this.thumbnail,
    this.qrCode,
    this.brandId,
    this.brandName,
    this.collectionId,
    this.collectionName,
    this.isActive = true,
  });

  Masterpiece copyWith({
    int? id,
    String? title,
    String? titleAr,
    int? year,
    String? shortDescription,
    String? longDescription,
    String? thumbnail,
    String? qrCode,
    int? brandId,
    String? brandName,
    int? collectionId,
    String? collectionName,
    bool? isActive,
  }) {
    return Masterpiece(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      year: year ?? this.year,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      thumbnail: thumbnail ?? this.thumbnail,
      qrCode: qrCode ?? this.qrCode,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      collectionId: collectionId ?? this.collectionId,
      collectionName: collectionName ?? this.collectionName,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'year': year,
      'short_description': shortDescription,
      'long_description': longDescription,
      'thumbnail': thumbnail,
      'qr_code': qrCode,
      'brand_id': brandId,
      'brand_name': brandName,
      'collection_id': collectionId,
      'collection_name': collectionName,
      'is_active': isActive,
    };
  }

  factory Masterpiece.fromMap(Map<String, dynamic> map) {
    return Masterpiece(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String,
      titleAr: map['title_ar'] as String?,
      year: map['year'] != null ? (map['year'] as num).toInt() : null,
      shortDescription: map['short_description'] as String?,
      longDescription: map['long_description'] as String?,
      thumbnail: map['thumbnail'] as String?,
      qrCode: map['qr_code'] as String?,
      brandId:
          map['brand_id'] != null ? (map['brand_id'] as num).toInt() : null,
      brandName: map['brand_name'] as String?,
      collectionId: map['collection_id'] != null
          ? (map['collection_id'] as num).toInt()
          : null,
      collectionName: map['collection_name'] as String?,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Masterpiece.fromJson(String source) =>
      Masterpiece.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Masterpiece(id: $id, title: $title, year: $year)';
}
