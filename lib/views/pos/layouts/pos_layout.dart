import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/views/pos/layouts/bottom_section.dart';
import 'package:readypos_flutter/views/pos/layouts/payment_type_section.dart';
import 'package:readypos_flutter/views/pos/components/pos_appBar.dart';
import 'package:readypos_flutter/views/pos/layouts/product_section.dart';
import 'package:readypos_flutter/views/pos/components/searchBar.dart';
import 'package:readypos_flutter/views/pos/layouts/summery_section.dart';

class POSLayout extends ConsumerStatefulWidget {
  const POSLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _POSLayoutState();
}

class _POSLayoutState extends ConsumerState<POSLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.isTabletLandsCape
              ? 140.h
              : 122.h - MediaQuery.of(context).padding.top,
        ),
        child: const POSAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MySearchBar(),
            // Gap(5.h),
            Divider(thickness: 1.5.r),
            ProductSection(),
            // Gap(5.h),
            Divider(thickness: 1.5.r),
            const SummerySection(),
            // Gap(5.h),
            Divider(thickness: 1.5.r),
            const PaymentTypeSection(),
            Gap(10.h),
          ],
        ),
      ),
      bottomNavigationBar: const BottomSection(),
    );
  }
}
