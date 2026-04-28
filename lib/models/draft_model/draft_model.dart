import 'dart:convert';

import 'data.dart';

class DraftModel {
  String? message;
  Data? data;

  DraftModel({this.message, this.data});

  factory DraftModel.fromMap(Map<String, dynamic> data) => DraftModel(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : Data.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DraftModel].
  factory DraftModel.fromJson(String data) {
    return DraftModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DraftModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
