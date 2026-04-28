import 'dart:convert';

class AccountModel {
  int? id;
  String? accountNo;
  String? name;
  dynamic initialBalance;
  double? totalBalance;
  String? note;

  AccountModel({
    this.id,
    this.accountNo,
    this.name,
    this.initialBalance,
    this.totalBalance,
    this.note,
  });

  factory AccountModel.fromMap(Map<String, dynamic> data) => AccountModel(
        id: data['id'] as int?,
        accountNo: data['account_no'] as String?,
        name: data['name'] as String?,
        initialBalance: data['initial_balance'] as dynamic,
        totalBalance: data['total_balance'] as double?,
        note: data['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'account_no': accountNo,
        'name': name,
        'initial_balance': initialBalance,
        'total_balance': totalBalance,
        'note': note,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AccountModel].
  factory AccountModel.fromJson(String data) {
    return AccountModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AccountModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
