import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/controllers/deposit_controller/deposit_controller.dart';
import 'package:readypos_flutter/models/deposit/account_model.dart';
import 'package:readypos_flutter/models/deposit/balance_model.dart';

final accountsControllerProvider =
    AsyncNotifierProvider<AccountsControllerProvider, List<AccountModel>>(
        AccountsControllerProvider.new);

final balanceControllerProvider =
    AutoDisposeAsyncNotifierProvider<BalanceControllerProvider, BalanceModel>(
        BalanceControllerProvider.new);

final balanceTransferProvider =
    NotifierProvider<BalanceTransfer, bool>(BalanceTransfer.new);
