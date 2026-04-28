// Bottom Navigation Tab Controller
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

final bottomTabControllerProvider =
    StateProvider<PageController>((ref) => PageController());

final selectedIndexProvider = StateProvider<int>((ref) => 0);

final pickedImageProvider = StateProvider<XFile?>((ref) => null);

final dashboardPeriodicProvider = StateProvider<String>((ref) => "daily");
final productId = StateProvider<int>((ref) => 0);

final productSearchType =
    AutoDisposeStateProviderFamily<Map<String, dynamic>?, String?>(
        (ref, arg) => {"name": null, "id": null});

final realTimeClockProvider = StreamProvider<String>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (i) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy | h:mm:ss').format(now);
    return formattedDate;
  });
});

extension ContextExtensions on BuildContext {
  bool get isTabletLandsCape {
    final shortestSide = MediaQuery.of(this).size.shortestSide;
    final orientation = MediaQuery.of(this).orientation;
    return shortestSide >= 600 && orientation == Orientation.landscape;
  }
}

final varientTextEditingProvider =
    StateProvider.family<TextEditingController, String>((ref, text) {
  return TextEditingController();
});

final productCodeProvider = StateProvider<String?>((ref) => null);

final isEditPriceProvider =
    AutoDisposeStateProvider.family<bool, int>((ref, id) => false);


final draftIdProvider = StateProvider<int?>((ref) => null);