import 'dart:convert';

import 'draft.dart';

class Data {
  int? total;
  List<Draft>? drafts;

  Data({this.total, this.drafts});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        total: data['total'] as int?,
        drafts: (data['drafts'] as List<dynamic>?)
            ?.map((e) => Draft.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'total': total,
        'drafts': drafts?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
