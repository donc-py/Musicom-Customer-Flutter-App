import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/warehouse_controller/warehouse.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/warehouse/warehouse.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/products/components/product_searchBar.dart';
import 'package:readypos_flutter/views/products/components/warehouse_card.dart';

class WarehousesLayout extends ConsumerStatefulWidget {
  const WarehousesLayout({super.key});

  @override
  ConsumerState<WarehousesLayout> createState() => _WarehousesLayoutState();
}

class _WarehousesLayoutState extends ConsumerState<WarehousesLayout> {
  final TextEditingController warehouseSearchController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ref.read(warehouseControllerProvider.notifier).warehouses == null) {
        ref.read(warehouseControllerProvider.notifier).getWarehouses(
              page: 1,
              perPage: 20,
              search: null,
              pagination: false,
            );
      }
    });
    scrollController.addListener(() {
      scrolListener();
    });
    warehouseSearchController.addListener(() {
      ref.read(warehouseControllerProvider.notifier).getWarehouses(
            page: 1,
            perPage: 20,
            search: warehouseSearchController.text,
            pagination: false,
          );
    });
    super.initState();
  }

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  void scrolListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(warehouseControllerProvider.notifier).warehouses!.length <
              ref.watch(warehouseControllerProvider.notifier).total!.toInt() &&
          !ref.watch(warehouseControllerProvider)) {
        scrollLoading = true;
        page++;
        ref.read(warehouseControllerProvider.notifier).getWarehouses(
              page: page,
              perPage: perPage,
              search: null,
              pagination: true,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        title: Text(
          S.of(context).warehouses,
          style: AppTextStyle.title,
        ),
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProductSearchBar(
                controller: warehouseSearchController,
                onChanged: (value) {},
              ),
              Gap(14.h),
              _buildProductListWidget(),
            ],
          ),
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: _buildFloatingActionButton(context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListWidget() {
    return Expanded(
      child: ref.watch(warehouseControllerProvider) && !scrollLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                warehouseSearchController.clear();
                ref.read(warehouseControllerProvider.notifier).getWarehouses(
                      page: 1,
                      perPage: perPage,
                      search: null,
                      pagination: false,
                    );
              },
              child: ListView.separated(
                itemCount: ref
                        .watch(warehouseControllerProvider.notifier)
                        .warehouses
                        ?.length ??
                    0,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  final Warehouse warehouse = ref
                      .watch(warehouseControllerProvider.notifier)
                      .warehouses![index];
                  return WarehouseCard(
                    warehouse: warehouse,
                    onTap: () {},
                  );
                }),
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                  indent: 20,
                  endIndent: 20,
                  color: AppColor.borderColor,
                ),
              ),
            ),
    );
  }

  Widget _buildFloatingActionButton({required BuildContext context}) {
    return Material(
      shape: const CircleBorder(),
      color: AppColor.primaryColor,
      child: InkWell(
        onTap: () {
          context.nav.pushNamed(Routes.warehousesAddUpdateView);
        },
        borderRadius: BorderRadius.circular(100.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60.h,
            width: 60.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: AppColor.whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
