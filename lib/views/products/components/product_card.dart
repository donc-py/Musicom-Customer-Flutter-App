// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/products/components/item_delete_dialog.dart';
import 'package:readypos_flutter/views/products/components/product_details_dialog.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final void Function()? onTap;
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });
  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  PopupMenu? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Stack(
      children: [
        Material(
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCategoryImage(),
                        Gap(10.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.brand ?? '',
                                  style: AppTextStyle.normalBody.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                Gap(2.r),
                                Text(
                                  widget.product.name ?? '',
                                  style: AppTextStyle.smallBody.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Gap(2.h),
                                Text(
                                  "${widget.product.category} | ${widget.product.code}",
                                  style: AppTextStyle.smallBody.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AdaptiveTheme.of(context).mode.isDark
                                        ? Colors.white
                                        : AppColor.darkBackgroundColor
                                            .withOpacity(0.6),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Gap(5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.product.qty.toString(),
                                      style: AppTextStyle.smallBody.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AdaptiveTheme.of(context)
                                                .mode
                                                .isDark
                                            ? Colors.white
                                            : AppColor.darkBackgroundColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          currency.currencyValue(
                                              widget.product.price ?? 0),
                                          style:
                                              AppTextStyle.smallBody.copyWith(
                                            color: AppColor.primaryColor,
                                          ),
                                        ),
                                        Gap(5.w),
                                        Container(
                                          width: 4.w,
                                          height: 4.h,
                                          decoration: const ShapeDecoration(
                                            color: AppColor.borderColor,
                                            shape: OvalBorder(),
                                          ),
                                        ),
                                        Gap(5.w),
                                        Text(
                                          widget.product.unit ?? '',
                                          style:
                                              AppTextStyle.smallBody.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AdaptiveTheme.of(context)
                                                    .mode
                                                    .isDark
                                                ? Colors.white
                                                : AppColor.darkBackgroundColor,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10.w,
          top: isLargeScreen ? 5.r : 0,
          child: PopupMenuButton<PopupMenu>(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : Colors.white,
            surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : Colors.white,
            initialValue: selectedMenu,
            onSelected: (PopupMenu value) {
              ref.read(productId.notifier).state = widget.product.id;
              switch (value) {
                case PopupMenu.view:
                  showDialog(
                      context: context,
                      builder: (context) => const ProductDetailsDialog());
                  break;
                case PopupMenu.delete:
                  // showDialog(
                  //   context: context,
                  //   barrierColor: AdaptiveTheme.of(context).mode.isDark
                  //       ? Colors.white.withOpacity(0.5)
                  //       : Colors.black.withOpacity(0.5),
                  //   builder: (context) => DeleteConfirmationDialog(
                  //     onPressed: () {
                  //       ref
                  //           .read(productControllerProvider.notifier)
                  //           .deleteProduct(id: widget.product.id)
                  //           .then((response) {
                  //         GlobalFunction.showCustomSnackbar(
                  //           message: response.message,
                  //           isSuccess: response.isSuccess,
                  //         );
                  //         if (response.isSuccess) {
                  //           ref
                  //               .read(productControllerProvider.notifier)
                  //               .getProducts(
                  //                 page: 1,
                  //                 perPage: 15,
                  //                 search: null,
                  //                 pagination: false,
                  //               );
                  //         }
                  //         context.nav.pop();
                  //       });
                  //     },
                  //   ),
                  // );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<PopupMenu>(
                value: PopupMenu.view,
                child: _buildPopUpItemWidget(
                    icon: Icons.visibility, name: S.of(context).view),
              ),
              // PopupMenuItem<PopupMenu>(
              //   value: PopupMenu.delete,
              //   child: _buildPopUpItemWidget(
              //       icon: Icons.delete, name: S.of(context).delete),
              // ),
            ],
          ),
        )
      ],
    );
  }

  Row _buildPopUpItemWidget({required IconData icon, required String name}) {
    return Row(
      children: [
        Icon(icon),
        Gap(10.w),
        Text(
          name,
          style: AppTextStyle.normalBody,
        ),
      ],
    );
  }

  Widget _buildCategoryImage() {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: const BorderSide(color: AppColor.borderColor, width: 1.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: widget.product.thumbnail != null
            ? CachedNetworkImage(
                imageUrl: widget.product.thumbnail!,
                width: context.isTabletLandsCape ? 75.w : 64.w,
                height: context.isTabletLandsCape ? 60.w : 64.h,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}

enum PopupMenu { view, delete }
