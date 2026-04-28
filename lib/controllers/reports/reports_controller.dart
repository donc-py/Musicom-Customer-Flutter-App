import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/reports/reports_model.dart';
import 'package:readypos_flutter/services/report_service_provider.dart';

final reportControllerProvider =
    StateNotifierProvider<ReportController, AsyncValue<Report>>((ref) {
  final controller = ReportController(ref);
  controller.getDashboardInfo();
  return controller;
});

class ReportController extends StateNotifier<AsyncValue<Report>> {
  final Ref ref;
  ReportController(this.ref) : super(const AsyncLoading());

  Future<void> getDashboardInfo() async {
    try {
      final response = await ref.read(reportServiceProvider).getReport();
      final data = Report.fromMap(response.data['data']);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
      throw stackTrace;
    }
  }
}
