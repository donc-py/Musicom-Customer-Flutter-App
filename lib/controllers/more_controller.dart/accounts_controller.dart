import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/more/account_model.dart';
import 'package:readypos_flutter/models/more/balance_sheet_model.dart';
import 'package:readypos_flutter/models/more/money_transfer_model.dart';
import 'package:readypos_flutter/services/more_service_provider.dart';

final accountingControllerProvider =
    StateNotifierProvider.family<AccountingController, bool, int>((ref, type) {
  return AccountingController(ref, type);
});

class AccountingController extends StateNotifier<bool> {
  final Ref ref;
  final int type;
  AccountingController(this.ref, this.type) : super(false);

  List<AccountModel> _accountList = [];
  List<MoneyTransferModel> _moneyTransferList = [];
  List<BalanceSheetModel> _balanceSheetList = [];

  List<AccountModel> get accountList => _accountList;
  List<MoneyTransferModel> get moneyTransferList => _moneyTransferList;
  List<BalanceSheetModel> get balanceSheetList => _balanceSheetList;

  Future<void> getAccounts({String? searchQuery}) async {
    try {
      state = true;
      final response = switch (type) {
        0 => searchQuery != null
            ? await ref
                .read(moreServiceProvider)
                .getAccounts(query: {'search': searchQuery, 'type': 'account'})
            : await ref
                .read(moreServiceProvider)
                .getAccounts(query: {'type': 'account'}),
        1 => searchQuery != null
            ? await ref.read(moreServiceProvider).getAccounts(
                query: {'search': searchQuery, 'type': 'money_transfer'})
            : await ref
                .read(moreServiceProvider)
                .getAccounts(query: {'type': 'money_transfer'}),
        2 => searchQuery != null
            ? await ref.read(moreServiceProvider).getAccounts(
                query: {'search': searchQuery, 'type': 'balance_sheet'})
            : await ref
                .read(moreServiceProvider)
                .getAccounts(query: {'type': 'balance_sheet'}),
        int() => null,
      };

      switch (type) {
        case 0:
          _accountList = [];
          final List<dynamic> accountData = response?.data['data']['accounts'];
          if (accountData.isNotEmpty) {
            _accountList =
                accountData.map((e) => AccountModel.fromMap(e)).toList();
          }
          break;
        case 1:
          _moneyTransferList = [];
          final List<dynamic> moneyTransferData =
              response?.data['data']['money_transfers'];
          if (moneyTransferData.isNotEmpty) {
            _moneyTransferList = moneyTransferData
                .map((e) => MoneyTransferModel.fromMap(e))
                .toList();
          }
          break;
        case 2:
          _balanceSheetList = [];
          final List<dynamic> balanceSheetData =
              response?.data['data']['balance_sheet'];
          if (balanceSheetData.isNotEmpty) {
            _balanceSheetList = balanceSheetData
                .map((e) => BalanceSheetModel.fromMap(e))
                .toList();
          }
          break;
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }
}
