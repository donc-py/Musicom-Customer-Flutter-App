import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/services/auth_service_provider.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  AuthController(this.ref) : super(false);

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      final response = await ref
          .read(authServiceProvider)
          .login(email: email, password: password);
      Box authBox = Hive.box(AppConstants.authBox);
      authBox.put(
          AppConstants.authToken, response.data['data']['access']['token']);
      authBox.put(AppConstants.userData, response.data['data']['user']);
      return true;
    } catch (e) {
      return false;
    } finally {
      state = false;
    }
  }
}
