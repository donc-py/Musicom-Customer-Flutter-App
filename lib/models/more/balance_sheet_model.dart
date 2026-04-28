import 'dart:convert';

class BalanceSheetModel {
  int? id;
  String? name;
  String? accountNo;
  double? credit;
  double? debit;
  double? balance;

  BalanceSheetModel({
    this.id,
    this.name,
    this.accountNo,
    this.credit,
    this.debit,
    this.balance,
  });

  factory BalanceSheetModel.fromMap(Map<String, dynamic> data) {
    return BalanceSheetModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
      accountNo: data['account_no'] as String?,
      credit: data['credit'] as double?,
      debit: data['debit'] as double?,
      balance: data['balance'] as double?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'account_no': accountNo,
        'credit': credit,
        'debit': debit,
        'balance': balance,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BalanceSheetModel].
  factory BalanceSheetModel.fromJson(String data) {
    return BalanceSheetModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BalanceSheetModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
