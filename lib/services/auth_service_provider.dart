import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/utils/api_client.dart';
import 'package:readypos_flutter/config/app_constants.dart';

final authServiceProvider = Provider((ref) => AuthService(ref));

abstract class AuthRepository {
  Future<Response> login({
    required String email,
    required String password,
  });
  Future<Response> profileUpdate({
    required Map<String, dynamic> data,
  });
  Future<Response> passwordChange({
    required Map<String, dynamic> data,
  });
  Future<Response> getAppCurrency();
}

class AuthService implements AuthRepository {
  final Ref ref;
  AuthService(this.ref);

  @override
  Future<Response> login(
      {required String email, required String password}) async {
    final response =
        await ref.read(apiClientProvider).post(AppConstants.loginUrl, data: {
      "email": email,
      "password": password,
    });

    return response;
  }

  @override
  Future<Response> profileUpdate({required Map<String, dynamic> data}) {
    final response = ref
        .read(apiClientProvider)
        .post(AppConstants.profileUpdate, data: data);
    return response;
  }

  @override
  Future<Response> passwordChange({required Map<String, dynamic> data}) {
    final response = ref
        .read(apiClientProvider)
        .put(AppConstants.passwordChange, data: data);
    return response;
  }

  @override
  Future<Response> getAppCurrency() {
    final response = ref.read(apiClientProvider).get(AppConstants.appcurrency);
    return response;
  }
  
}
