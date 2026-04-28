import 'dart:convert';

class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? companyName;
  String? profilePhoto;
  String? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.companyName,
    this.profilePhoto,
    this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        companyName: data['company_name'] as String?,
        profilePhoto: data['profile_photo'] as String?,
        role: data['role'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'company_name': companyName,
        'profile_photo': profilePhoto,
        'role': role,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserModel].
  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
