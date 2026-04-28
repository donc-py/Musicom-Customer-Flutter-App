import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/deposit/account_model.dart';
import 'package:readypos_flutter/models/deposit/balance_model.dart';
import 'package:readypos_flutter/services/deposit_pos_service_provider.dart';

class AccountsControllerProvider extends AsyncNotifier<List<AccountModel>> {
  @override
  Future<List<AccountModel>> build() async {
    final response = await ref.read(depositServiceProvider).getAccounts();
    final accountList = (response.data['data']['accounts'] as List<dynamic>)
        .map((e) => AccountModel.fromMap(e))
        .toList();
    return accountList;
  }
}

class BalanceControllerProvider extends AutoDisposeAsyncNotifier<BalanceModel> {
  @override
  Future<BalanceModel> build() async {
    final response = await ref.read(depositServiceProvider).getBalance();
    final balance = response.data['data']['balance'];
    final todaySales = response.data['data']['todaySale'];
    return BalanceModel(balance: balance, todaySales: todaySales);
  }
}

class BalanceTransfer extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<bool> depositBalanceTransfer(
      {required Map<String, dynamic> data}) async {
    state = true;
    final response =
        await ref.read(depositServiceProvider).balanceTransfer(data: data);
    if (response.statusCode == 200) {
      state = false;
      return true;
    }
    state = false;
    return false;
  }
}
