import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/news/news.dart';
import 'package:readypos_flutter/services/news_service_provider.dart';

final newsControllerProvider =
    StateNotifierProvider<NewsController, bool>((ref) => NewsController(ref));

class NewsController extends StateNotifier<bool> {
  final Ref ref;
  NewsController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<News>? _news;
  List<News>? get news => _news;

  Future<void> getNews({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
    String? category,
  }) async {
    try {
      state = true;
      final response = await ref.read(newsServiceProvider).getNews(
            search: search,
            perPage: perPage,
            page: page,
            category: category,
          );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];
        _total = data['total'] as int?;

        if (data['news'] != null) {
          final List<dynamic> items = data['news'] as List<dynamic>;
          final parsed = items
              .map((e) => News.fromMap(e as Map<String, dynamic>))
              .toList();

          if (pagination && _news != null) {
            _news!.addAll(parsed);
          } else {
            _news = parsed;
          }
        }
      }
    } catch (e, st) {
      debugPrint('Error fetching news: $e');
      debugPrint('$st');
    } finally {
      state = false;
    }
  }
}
