import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final customerServiceProvider = Provider<CustomerService>((ref) {
  return CustomerService(ref);
});

abstract class CustomerRepository {
  Future<Response> getCustomers();
  Future<Response> getSearchedCustomers({required String query});
  Future<Response> getCustomersGroup();
  Future<Response> addCustomer({required Map<String, dynamic> data});
}

class CustomerService implements CustomerRepository {
  final Ref ref;

  CustomerService(this.ref);

  @override
  Future<Response> getCustomers() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.customers);
    return response;
  }

  @override
  Future<Response> getSearchedCustomers({required String query}) {
    final response = ref.read(apiClientProvider).get(
      AppConstants.customers,
      query: {'search': query},
    );
    return response;
  }

  @override
  Future<Response> getCustomersGroup() {
    final response = ref.read(apiClientProvider).get(
          AppConstants.customersGroup,
        );
    return response;
  }

  @override
  Future<Response> addCustomer({required Map<String, dynamic> data}) {
    final response = ref.read(apiClientProvider).post(
          AppConstants.addCustomer,
          data: data,
        );
    return response;
  }
}
