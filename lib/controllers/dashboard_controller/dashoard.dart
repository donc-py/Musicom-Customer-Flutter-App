import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/models/dashboard/dashboard.dart';
import 'package:readypos_flutter/services/dashboard_service_provider.dart';

final dashboardInfoControllerProvider =
    StateNotifierProvider<DashboardController, AsyncValue<DashboardInfo>>(
        (ref) {
  final controller = DashboardController(ref);
  String type = ref.watch(dashboardPeriodicProvider);
  controller.getDashboardInfo(type: type.toLowerCase());
  return controller;
});

class DashboardController extends StateNotifier<AsyncValue<DashboardInfo>> {
  final Ref ref;
  DashboardController(this.ref) : super(const AsyncLoading());

  Future<void> getDashboardInfo({required String type}) async {
    try {
      final response =
          await ref.read(dashboardServiceProvider).getDashboardInfo(type: type);
      final data = DashboardInfo.fromMap(response.data['data']);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
      throw stackTrace;
    }
  }
}
