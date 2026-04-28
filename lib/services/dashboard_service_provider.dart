import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final dashboardServiceProvider =
    Provider<DashboardService>((ref) => DashboardService(ref));

abstract class DashboardRepository {
  Future<Response> getDashboardInfo({required String type});
}

class DashboardService implements DashboardRepository {
  final Ref ref;
  DashboardService(this.ref);
  @override
  Future<Response> getDashboardInfo({required String type}) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['type'] = type;
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.dashboard, query: queryParams);
    return response;
  }
}
