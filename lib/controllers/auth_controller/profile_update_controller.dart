import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/services/auth_service_provider.dart';

final profileUpdateControllerProvider =
    StateNotifierProvider<ProfileUpdateController, bool>(
  (ref) => ProfileUpdateController(ref),
);

class ProfileUpdateController extends StateNotifier<bool> {
  final Ref ref;
  ProfileUpdateController(this.ref) : super(false);

  Future<bool> profileUpdate(Map<String, dynamic> data) async {
    state = true;
    try {
      final response =
          await ref.read(authServiceProvider).profileUpdate(data: data);
      if (response.statusCode == 200) {
        Box authBox = Hive.box(AppConstants.authBox);
        authBox.put(AppConstants.userData, response.data['data']['user']);
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
