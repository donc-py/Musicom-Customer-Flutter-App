import 'package:flutter_riverpod/flutter_riverpod.dart';

final startDateProvider =
    StateProvider.family<String, String>((ref, flag) => '');
final endDateProvider = StateProvider.family<String, String>((ref, flag) => '');

final warehouseIdProvider =
    StateProvider.family<int?, String>((ref, flag) => null);
