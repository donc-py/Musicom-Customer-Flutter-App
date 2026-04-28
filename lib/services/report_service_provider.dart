import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final reportServiceProvider = Provider((ref) => ReportService(ref));

abstract class ReportRepository {
  Future<Response> getReport();
}

class ReportService implements ReportRepository {
  final Ref ref;
  ReportService(this.ref);

  @override
  Future<Response> getReport() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstants.report,
        );

    return response;
  }
}
