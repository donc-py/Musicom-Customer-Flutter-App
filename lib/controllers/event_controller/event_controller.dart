import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/event/event.dart';
import 'package:readypos_flutter/services/event_service_provider.dart';

final eventControllerProvider =
    StateNotifierProvider<EventController, bool>((ref) => EventController(ref));

class EventController extends StateNotifier<bool> {
  final Ref ref;
  EventController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Event>? _events;
  List<Event>? get events => _events;

  Future<void> getEvents({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
    bool upcoming = false,
  }) async {
    try {
      state = true;
      final response = await ref.read(eventServiceProvider).getEvents(
            search: search,
            perPage: perPage,
            page: page,
            upcoming: upcoming,
          );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];
        _total = data['total'] as int?;

        if (data['events'] != null) {
          final List<dynamic> items = data['events'] as List<dynamic>;
          final parsed = items
              .map((e) => Event.fromMap(e as Map<String, dynamic>))
              .toList();

          if (pagination && _events != null) {
            _events!.addAll(parsed);
          } else {
            _events = parsed;
          }
        }
      }
    } catch (e, st) {
      debugPrint('Error fetching events: $e');
      debugPrint('$st');
    } finally {
      state = false;
    }
  }
}
