import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/pos_product_controller/product_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/utils/barCode_scanner.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/pos/components/customer_shimmerEffect.dart';

class SearchAppBar extends ConsumerStatefulWidget {
  const SearchAppBar({
    super.key,
  });

  @override
  ConsumerState<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends ConsumerState<SearchAppBar> {
  @override
  void dispose() {
    print("Dispose is called");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Hero(
      tag: "searchBar",
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : Colors.white,
            // give boder bottom with 1px
            border: Border(
              bottom: BorderSide(
                color: AdaptiveTheme.of(context).mode.isDark
                    ? AppColor.darkBackgroundColor
                    : AppColor.blueBackgroundColor,
                width: 1.5.h,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(50.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // height: context.isTabletLandsCape ? 110.h : 70.h,
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? AppColor.darkBackgroundColor
                          : Colors.white,
                      padding: EdgeInsets.all(8.r),
                      child: Container(
                        // height: 48.h,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.borderColor,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              context.isTabletLandsCape
                                  ? SizedBox(
                                      child: SvgPicture.asset(
                                        Assets.svgs.searchNormal,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : SizedBox(
                                      width: 24.r,
                                      height: 24.r,
                                      child: SvgPicture.asset(
                                        Assets.svgs.searchNormal,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Gap(12.w),
                              Expanded(
                                child: TextField(
                                  style: isLargeScreen
                                      ? AppTextStyle.normalBody
                                      : AppTextStyle.normalBody.copyWith(
                                          fontSize: 14.sp,
                                        ),
                                  decoration: InputDecoration(
                                    hintText: "Search product",
                                    hintStyle: AppTextStyle.normalBody.copyWith(
                                      color: AppColor.borderColor,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    ref
                                        .read(posProductsControllerProvider
                                            .notifier)
                                        .getProducts(
                                          search: value,
                                        );
                                  },
                                ),
                              ),
                              Container(
                                width: 1.w,
                                height: 24.h,
                                color: AppColor.borderColor,
                              ),
                              Gap(12.w),
                              InkWell(
                                onTap: () async {
                                  // await barCodeScanner(
                                  //   context: context,
                                  //   ref: ref,
                                  // );
                                },
                                child: context.isTabletLandsCape
                                    ? SvgPicture.asset(
                                        Assets.svgs.scan,
                                        fit: BoxFit.cover,
                                        height: 40.h,
                                      )
                                    : SvgPicture.asset(
                                        Assets.svgs.scan,
                                        fit: BoxFit.cover,
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.nav.pop();
                    },
                    child: Stack(
                      children: [
                        context.isTabletLandsCape
                            ? Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AdaptiveTheme.of(context).mode.isDark
                                      ? AppColor.greyBackgroundColor
                                          .withOpacity(0.2)
                                      : AppColor.greyBackgroundColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: SvgPicture.asset(
                                  Assets.svgs.shopCard,
                                  colorFilter:
                                      AdaptiveTheme.of(context).mode.isDark
                                          ? const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            )
                                          : ColorFilter.mode(
                                              Colors.black.withOpacity(0.5),
                                              BlendMode.srcIn,
                                            ),
                                ),
                              )
                            : Container(
                                height: 48.r,
                                width: 48.r,
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: AdaptiveTheme.of(context).mode.isDark
                                      ? AppColor.greyBackgroundColor
                                          .withOpacity(0.2)
                                      : AppColor.greyBackgroundColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: SvgPicture.asset(
                                  Assets.svgs.shopCard,
                                  colorFilter:
                                      AdaptiveTheme.of(context).mode.isDark
                                          ? const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            )
                                          : ColorFilter.mode(
                                              Colors.black.withOpacity(0.5),
                                              BlendMode.srcIn,
                                            ),
                                ),
                              ),
                        context.isTabletLandsCape
                            ? ValueListenableBuilder(
                                valueListenable: Hive.box<HiveCartModel>(
                                        AppConstants.cartBox)
                                    .listenable(),
                                builder: (context, box, _) {
                                  return Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 10.r,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        box.values.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : ValueListenableBuilder(
                                valueListenable: Hive.box<HiveCartModel>(
                                        AppConstants.cartBox)
                                    .listenable(),
                                builder: (context, box, _) {
                                  return Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 10.r,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        box.values.length.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp),
                                      ),
                                    ),
                                  );
                                }),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                // height: 55.h,
                width: double.infinity,
                child: FormBuilderDropdown<String>(
                  name: 'searchType',
                  initialValue: 'All Product',
                  icon: SvgPicture.asset(
                    Assets.svgs.arrowDown2,
                    fit: BoxFit.cover,
                  ),
                  isDense: isLargeScreen ? false : true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                  ),
                  items: ["All Product", "Categories", "Brands"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: AppTextStyle.normalBody,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value == "Categories") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const _SearchCategoryOrBrands(
                              flag: "category",
                            );
                          });
                      ref
                          .read(categoryControllerProvider.notifier)
                          .getCategories(
                            page: 1,
                            perPage: 30,
                            search: "",
                            pagination: false,
                          );
                    } else if (value == "Brands") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const _SearchCategoryOrBrands(
                              flag: "brand",
                            );
                          });
                      ref.read(brandControllerProvider.notifier).getBrands(
                            page: 1,
                            perPage: 30,
                            search: "",
                            pagination: false,
                          );
                    } else {
                      ref.read(productSearchType('category').notifier).state = {
                        "name": "All Product",
                        'id': null
                      };
                      ref.read(productSearchType('brand').notifier).state = {
                        "name": "All Product",
                        'id': null
                      };
                      ref
                          .read(posProductsControllerProvider.notifier)
                          .getProducts();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchCategoryOrBrands extends ConsumerStatefulWidget {
  const _SearchCategoryOrBrands({
    required this.flag,
  });

  final String flag;

  @override
  ConsumerState<_SearchCategoryOrBrands> createState() =>
      _SearchCategoryOrBrandsState();
}

class _SearchCategoryOrBrandsState
    extends ConsumerState<_SearchCategoryOrBrands> {
  @override
  Widget build(BuildContext context) {
    final isLoadingCategory = ref.watch(categoryControllerProvider);
    final isLoadingBrand = ref.watch(brandControllerProvider);
    var categoryList =
        ref.watch(categoryControllerProvider.notifier).categories;
    var brandList = ref.watch(brandControllerProvider.notifier).brands;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: TextField(
                decoration: InputDecoration(
                  hintText: widget.flag == 'category'
                      ? "Search Category"
                      : widget.flag == 'brand'
                          ? "Search Brand"
                          : "Search",
                  hintStyle: AppTextStyle.normalBody.copyWith(
                    color: AppColor.borderColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppColor.borderColor,
                      width: 1.w,
                    ),
                  ),
                  isDense: true,
                ),
                onChanged: (value) {
                  if (widget.flag == 'category') {
                    ref.read(categoryControllerProvider.notifier).getCategories(
                          page: 1,
                          perPage: 30,
                          search: value,
                          pagination: false,
                        );
                  } else if (widget.flag == 'brand') {
                    ref.read(brandControllerProvider.notifier).getBrands(
                          page: 1,
                          perPage: 30,
                          search: value,
                          pagination: false,
                        );
                  }
                },
              ),
            ),
          ),
          Gap(12.h),
          widget.flag == 'category'
              ? Expanded(
                  child: isLoadingCategory
                      ? const CustomerShimmer()
                      : categoryList == null
                          ? const Center(
                              child: Text("No Data found"),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10.r,
                                  mainAxisSpacing: 20.r,
                                  mainAxisExtent: 116.h,
                                ),
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      ref
                                          .read(productSearchType('category')
                                              .notifier)
                                          .state = {
                                        "name": categoryList[index].name,
                                        'id': categoryList[index].id
                                      };
                                      ref
                                          .read(posProductsControllerProvider
                                              .notifier)
                                          .getProducts();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      // color: Colors.blue,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            height: 70.r,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: AppColor.borderColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  categoryList[index].thumbnail,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              categoryList[index].name,
                                              style: AppTextStyle.normalBody
                                                  .copyWith(fontSize: 14.sp),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Center(
                                          //   child: Text(
                                          //     "(${categoryList[index].totalProducts})",
                                          //     style: AppTextStyle.normalBody
                                          //         .copyWith(
                                          //       fontSize: 14.sp,
                                          //       color: Colors.grey,
                                          //     ),
                                          //     textAlign: TextAlign.center,
                                          //     overflow: TextOverflow.ellipsis,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                )
              : widget.flag == 'brand'
                  ? Expanded(
                      child: isLoadingBrand
                          ? const CustomerShimmer()
                          : brandList == null
                              ? const Center(
                                  child: Text("No Data found"),
                                )
                              : Scrollbar(
                                  child: ListView.separated(
                                    itemCount: brandList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Container(
                                          height: 60.r,
                                          width: 60.r,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: AppColor.borderColor,
                                              width: 1.w,
                                            ),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                brandList[index].thumbnail,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(brandList[index].name),
                                            // Text(
                                            //   "${brandList[index].totalProducts} Products",
                                            //   style: AppTextStyle.normalBody
                                            //       .copyWith(
                                            //     fontSize: 14.sp,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18.r,
                                        ),
                                        onTap: () {
                                          ref
                                              .read(productSearchType('brand')
                                                  .notifier)
                                              .state = {
                                            "name": brandList[index].name,
                                            'id': brandList[index].id
                                          };
                                          ref
                                              .read(
                                                  posProductsControllerProvider
                                                      .notifier)
                                              .getProducts();

                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.r),
                                      child: const Divider(
                                        thickness: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                    )
                  : const SizedBox(),
          // press ok button
          SizedBox(
            width: 0.6.sw,
            child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Close"),
          ),
          Gap(10.h),
        ],
      ),
    );
  }
}
