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
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/products/components/product_detail_sheet.dart';

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

    // FIX BUG-012: usar ?? '' para evitar "null" literal en pantalla
    final category = widget.product.category ?? '';
    final code = widget.product.code ?? '';
    final categoryCode =
        [category, code].where((s) => s.isNotEmpty).join(' | ');

    return Stack(
      children: [
        Material(
          child: InkWell(
            // FIX: tap en la card abre el sheet de detalle
            onTap: widget.onTap ??
                () => ProductDetailSheet.show(context, product: widget.product),
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
                                // FIX BUG-012: solo muestra si hay contenido
                                if (categoryCode.isNotEmpty)
                                  Text(
                                    categoryCode,
                                    style: AppTextStyle.smallBody.copyWith(
                                      fontSize: 12.sp,
                                      color:
                                          AdaptiveTheme.of(context).mode.isDark
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
                                    // FIX BUG-012: qty null → '' en lugar de "null"
                                    if (widget.product.qty != null)
                                      Text(
                                        'Qtà: ${widget.product.qty}',
                                        style: AppTextStyle.smallBody.copyWith(
                                          fontSize: 12.sp,
                                          color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark
                                              ? Colors.white
                                              : AppColor.darkBackgroundColor,
                                        ),
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    Row(
                                      children: [
                                        // FIX BUG-013: formato €XX.XX
                                        Text(
                                          '${(widget.product.price ?? 0.0).toStringAsFixed(2)} €',
                                          style:
                                              AppTextStyle.smallBody.copyWith(
                                            color: AppColor.primaryColor,
                                          ),
                                        ),
                                        if (widget.product.unit != null &&
                                            widget.product.unit!.isNotEmpty)
                                          Row(
                                            children: [
                                              Gap(5.w),
                                              Container(
                                                width: 4.w,
                                                height: 4.h,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: AppColor.borderColor,
                                                  shape: OvalBorder(),
                                                ),
                                              ),
                                              Gap(5.w),
                                              Text(
                                                widget.product.unit!,
                                                style: AppTextStyle.smallBody
                                                    .copyWith(
                                                  fontSize: 12.sp,
                                                  color: AdaptiveTheme.of(
                                                              context)
                                                          .mode
                                                          .isDark
                                                      ? Colors.white
                                                      : AppColor
                                                          .darkBackgroundColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
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

        // ── menú ⋮ ──────────────────────────────────────────────────────
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
              switch (value) {
                case PopupMenu.view:
                  // FIX BUG-011: abre el ProductDetailSheet en lugar del dialog roto
                  ProductDetailSheet.show(context, product: widget.product);
                  break;
                case PopupMenu.delete:
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<PopupMenu>(
                value: PopupMenu.view,
                // FIX: texto en italiano
                child: _buildPopUpItemWidget(
                    icon: Icons.visibility, name: 'Dettagli'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildPopUpItemWidget({required IconData icon, required String name}) {
    return Row(
      children: [
        Icon(icon),
        Gap(10.w),
        Text(name, style: AppTextStyle.normalBody),
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
        child: widget.product.thumbnail != null &&
                widget.product.thumbnail!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.product.thumbnail!,
                width: context.isTabletLandsCape ? 75.w : 64.w,
                height: context.isTabletLandsCape ? 60.w : 64.h,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: context.isTabletLandsCape ? 75.w : 64.w,
                  height: context.isTabletLandsCape ? 60.w : 64.h,
                  color: Colors.grey[100],
                  child: Icon(Icons.image, color: Colors.grey[300], size: 24.r),
                ),
              )
            : Container(
                width: context.isTabletLandsCape ? 75.w : 64.w,
                height: context.isTabletLandsCape ? 60.w : 64.h,
                color: Colors.grey[100],
                child: Icon(Icons.image, color: Colors.grey[300], size: 24.r),
              ),
      ),
    );
  }
}

enum PopupMenu { view, delete }
