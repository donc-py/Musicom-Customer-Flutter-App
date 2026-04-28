import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/services/masterpiece_service_provider.dart';

final masterpieceControllerProvider =
    StateNotifierProvider<MasterpieceController, bool>(
        (ref) => MasterpieceController(ref));

class MasterpieceController extends StateNotifier<bool> {
  final Ref ref;
  MasterpieceController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Masterpiece>? _masterpieces;
  List<Masterpiece>? get masterpieces => _masterpieces;

  Future<void> getMasterpieces({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
    int? collectionId,
    int? brandId,
  }) async {
    try {
      state = true;
      final response =
          await ref.read(masterpieceServiceProvider).getMasterpieces(
                search: search,
                perPage: perPage,
                page: page,
                collectionId: collectionId,
                brandId: brandId,
              );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];
        _total = data['total'] as int?;

        if (data['masterpieces'] != null) {
          final List<dynamic> items = data['masterpieces'] as List<dynamic>;

          if (pagination && _masterpieces != null) {
            final newItems = items
                .map((e) => Masterpiece.fromMap(e as Map<String, dynamic>))
                .toList();
            _masterpieces!.addAll(newItems);
          } else {
            _masterpieces = items
                .map((e) => Masterpiece.fromMap(e as Map<String, dynamic>))
                .toList();
          }
        }
      }
    } catch (e, st) {
      debugPrint('Error fetching masterpieces: $e');
      debugPrint('$st');
    } finally {
      state = false;
    }
  }
}
