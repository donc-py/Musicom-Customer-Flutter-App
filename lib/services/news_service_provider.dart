import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final newsServiceProvider = Provider((ref) => NewsService(ref));

abstract class NewsRepository {
  Future<Response> getNews({
    required String? search,
    required int? perPage,
    required int? page,
    String? category,
  });
}

class NewsService implements NewsRepository {
  final Ref ref;
  NewsService(this.ref);

  @override
  Future<Response> getNews({
    required String? search,
    required int? perPage,
    required int? page,
    String? category,
  }) async {
    final Map<String, dynamic> q = {};
    if (search != null) q['search'] = search;
    q['page'] = page;
    q['per_page'] = perPage;
    if (category != null) q['category'] = category;

    return ref.read(apiClientProvider).get(AppConstants.news, query: q);
  }
}
