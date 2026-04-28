import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_controller.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/views/draft/components/draft_appBar.dart';
import 'package:readypos_flutter/views/draft/components/draft_card.dart';

class DraftLayout extends ConsumerWidget {
  const DraftLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(draftControllerProvider);
    final draftNotifier = ref.watch(draftControllerProvider.notifier);
    return Scaffold(
      // backgroundColor: AdaptiveTheme.of(context).mode.isDark
      //     ? AppColor.darkBackgroundColor
      //     : Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.isTabletLandsCape
              ? 140.h
              : 100.h - MediaQuery.of(context).padding.top,
        ),
        child: const DraftAppBar(),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : draftNotifier.draftModel?.data?.drafts?.length == 0
              ? const Center(
                  child: Text("No Draft Found"),
                )
              : ListView.builder(
                  itemCount:
                      draftNotifier.draftModel?.data?.drafts?.length ?? 0,
                  itemBuilder: (context, index) {
                    return DraftCard(
                      index: index,
                      draftModel:
                          draftNotifier.draftModel?.data?.drafts?[index],
                      onPressed: () async {
                        if (draftNotifier.draftModel?.data?.drafts?[index] ==
                            null) {
                          return;
                        }

                        final cartBox =
                            Hive.box<HiveCartModel>(AppConstants.cartBox);

                        // Check if the cart already has data
                        if (cartBox.isNotEmpty) {
                          // Clear the cart
                          await cartBox.clear();
                        }

                        // Store the draft ID
                        ref.read(draftIdProvider.notifier).state =
                            draftNotifier.draftModel!.data!.drafts![index].id;

                        // Add new items to the cart
                        for (var i = 0;
                            i <
                                draftNotifier.draftModel!.data!.drafts![index]
                                    .products!.length;
                            i++) {
                          HiveCartModel hiveCartModel = HiveCartModel(
                            id: draftNotifier.draftModel!.data!.drafts![index]
                                    .products![i].id ??
                                0,
                            name: draftNotifier.draftModel!.data!.drafts![index]
                                    .products![i].name ??
                                '',
                            code: draftNotifier.draftModel!.data!.drafts![index]
                                    .products![i].code ??
                                '',
                            thumbnail: draftNotifier.draftModel!.data!
                                    .drafts![index].products![i].thumbnail ??
                                '',
                            subTotal: draftNotifier.draftModel!.data!
                                    .drafts![index].products![i].subTotal ??
                                0,
                            productsQTY: draftNotifier.draftModel!.data!
                                    .drafts![index].products![i].quantity ??
                                0,
                          );

                          await cartBox.add(hiveCartModel);
                        }

                        // Pop the screen
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
    );
  }
}
