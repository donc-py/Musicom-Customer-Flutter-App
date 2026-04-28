class BalanceModel {
  final double balance;
  final double todaySales;

  BalanceModel({required this.balance, required this.todaySales});

  // copyWith method
  BalanceModel copyWith({
    double? balance,
    double? todaySales,
  }) {
    return BalanceModel(
      balance: balance ?? this.balance,
      todaySales: todaySales ?? this.todaySales,
    );
  }
}
