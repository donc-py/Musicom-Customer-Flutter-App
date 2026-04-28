import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class ProductsHubLayout extends ConsumerStatefulWidget {
  const ProductsHubLayout({super.key, this.title});
  final String? title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsLayoutState();
}

class _ProductsLayoutState extends ConsumerState<ProductsHubLayout> {
  List<_ProductModel> getProductModel(BuildContext context) {
    return [
      _ProductModel(icon: Assets.svgs.category, name: S.of(context).categories),
      _ProductModel(icon: Assets.svgs.box, name: S.of(context).products),
      _ProductModel(icon: Assets.svgs.medal, name: S.of(context).brands),
      _ProductModel(icon: Assets.svgs.shop, name: S.of(context).warehouses),
      _ProductModel(icon: Assets.svgs.boxAdd, name: S.of(context).addProducts),
    ];
  }

  void navigateScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.nav.pushNamed(Routes.categories);
        break;
      case 1:
        context.nav.pushNamed(Routes.productView);
        break;
      case 2:
        context.nav.pushNamed(Routes.brandsView);
        break;
      case 3:
        context.nav.pushNamed(Routes.warehousesView);
        break;
      case 4:
        context.nav.pushNamed(Routes.addProductsView);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              mainAxisExtent: context.isTabletLandsCape ? 350.h : 174.0.h,
            ),
            itemCount: getProductModel(context).length,
            itemBuilder: (context, index) {
              return _ProductCard(
                icon: getProductModel(context)[index].icon,
                title: getProductModel(context)[index].name,
                onTap: () {
                  navigateScreen(context, index);
                },
              );
            }),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AdaptiveTheme.of(context).mode.isDark
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.15),
                  spreadRadius: 0.8,
                  blurRadius: 6,
                  offset: const Offset(0, -3),
                ),
              ]
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onTap(),
          splashColor: AppColor.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                context.isTabletLandsCape
                    ? SvgPicture.asset(
                        icon,
                        fit: BoxFit.cover,
                        height: 80.h,
                      )
                    : SizedBox(
                        child: SvgPicture.asset(
                          icon,
                          fit: BoxFit.cover,
                          height: 45.h,
                        ),
                      ),
                Gap(16.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductModel {
  final String icon;
  final String name;
  _ProductModel({required this.icon, required this.name});
}
