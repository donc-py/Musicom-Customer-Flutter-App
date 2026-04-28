import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/warehouse_controller/warehouse.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/models/warehouse/warehouse.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/products/components/item_delete_dialog.dart';

class WarehouseCard extends StatefulWidget {
  final Warehouse warehouse;
  final void Function()? onTap;
  const WarehouseCard({
    super.key,
    required this.warehouse,
    this.onTap,
  });
  @override
  State<WarehouseCard> createState() => _WarehouseCardState();
}

class _WarehouseCardState extends State<WarehouseCard> {
  PopupMenu? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.warehouse.name ?? '',
                                  style: AppTextStyle.normalBody.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Gap(8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 2),
                                  decoration: ShapeDecoration(
                                    color: AdaptiveTheme.of(context).mode.isDark
                                        ? Colors.grey.withOpacity(0.2)
                                        : AppColor.darkBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                  ),
                                  child: Text(
                                    widget.warehouse.totalPurchages.toString(),
                                    style: AppTextStyle.smallBody
                                        .copyWith(color: AppColor.whiteColor),
                                  ),
                                )
                              ],
                            ),
                            Gap(5.h),
                            _buildInfoRowWidget(
                              icon: Assets.svgs.mobile,
                              info: widget.warehouse.phone,
                            ),
                            Gap(5.h),
                            _buildInfoRowWidget(
                              icon: Assets.svgs.sms,
                              info: widget.warehouse.email,
                            ),
                            Gap(5.h),
                            _buildInfoRowWidget(
                              icon: Assets.svgs.location,
                              info: widget.warehouse.address,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.nav.pushNamed(
                                Routes.warehousesAddUpdateView,
                                arguments: widget.warehouse,
                              );
                            },
                            child: SvgPicture.asset(
                              Assets.svgs.edit,
                              width: 18.sp,
                            ),
                          ),
                          Gap(20.h),
                          Consumer(builder: (context, ref, _) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor:
                                      AdaptiveTheme.of(context).mode.isDark
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.black.withOpacity(0.5),
                                  builder: (context) =>
                                      DeleteConfirmationDialog(
                                    onPressed: () {
                                      ref
                                          .read(warehouseControllerProvider
                                              .notifier)
                                          .deleteWarehouse(
                                            id: widget.warehouse.id,
                                          )
                                          .then((response) {
                                        GlobalFunction.showCustomSnackbar(
                                          message: response.message,
                                          isSuccess: response.isSuccess,
                                        );
                                        if (response.isSuccess) {
                                          ref
                                              .read(warehouseControllerProvider
                                                  .notifier)
                                              .getWarehouses(
                                                page: 1,
                                                perPage: 15,
                                                search: null,
                                                pagination: false,
                                              );
                                        }
                                        context.nav.pop();
                                      });
                                    },
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                Assets.svgs.trash,
                                width: 18.sp,
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWidget({required String icon, required String? info}) {
    return info != null
        ? Row(
            children: [
              SvgPicture.asset(icon),
              Gap(5.w),
              Expanded(
                child: Text(
                  info,
                  style: AppTextStyle.smallBody.copyWith(
                    fontSize: 12.sp,
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? Colors.white
                        : AppColor.darkBackgroundColor.withOpacity(0.7),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}

enum PopupMenu { view, delete }
