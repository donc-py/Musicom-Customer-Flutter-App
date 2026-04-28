import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/services/auth_service_provider.dart';

final passwordChangeControllerProvider =
    StateNotifierProvider<PasswordChangeController, bool>((ref) {
  return PasswordChangeController(ref);
});

class PasswordChangeController extends StateNotifier<bool> {
  final Ref ref;
  PasswordChangeController(this.ref) : super(false);

  Future<bool> passwordChange(Map<String, dynamic> data) async {
    state = true;
    try {
      final response =
          await ref.read(authServiceProvider).passwordChange(data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      state = false;
      return false;
    } finally {
      state = false;
    }
  }
}
