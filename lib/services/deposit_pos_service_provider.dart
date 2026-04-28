import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final depositServiceProvider =
    Provider<DepositPOSRepository>((ref) => DepositPOSService(ref));

abstract class DepositPOSRepository {
  Future<Response> getAccounts();
  Future<Response> getBalance();
  Future<Response> balanceTransfer({required Map<String, dynamic> data});
}

class DepositPOSService implements DepositPOSRepository {
  final Ref ref;
  DepositPOSService(this.ref);
  @override
  Future<Response> getAccounts() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.bankAccount);
    return response;
  }

  @override
  Future<Response> getBalance() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.balance);
    return response;
  }

  @override
  Future<Response> balanceTransfer({required Map<String, dynamic> data}) async {
    final response = ref
        .read(apiClientProvider)
        .post(AppConstants.balanceTransfer, data: data);
    return response;
  }
}
