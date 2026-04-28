import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final eventServiceProvider = Provider((ref) => EventService(ref));

abstract class EventRepository {
  Future<Response> getEvents({
    required String? search,
    required int? perPage,
    required int? page,
    bool upcoming,
  });
}

class EventService implements EventRepository {
  final Ref ref;
  EventService(this.ref);

  @override
  Future<Response> getEvents({
    required String? search,
    required int? perPage,
    required int? page,
    bool upcoming = false,
  }) async {
    final Map<String, dynamic> q = {};
    if (search != null) q['search'] = search;
    q['page'] = page;
    q['per_page'] = perPage;
    if (upcoming) q['upcoming'] = true;

    return ref.read(apiClientProvider).get(AppConstants.events, query: q);
  }
}
