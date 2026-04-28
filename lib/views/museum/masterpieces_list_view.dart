import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/routes.dart';

class MasterpiecesListView extends ConsumerStatefulWidget {
  const MasterpiecesListView({super.key});

  @override
  ConsumerState<MasterpiecesListView> createState() =>
      _MasterpiecesListViewState();
}

class _MasterpiecesListViewState extends ConsumerState<MasterpiecesListView> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  int _page = 1;
  bool _scrollLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(masterpieceControllerProvider.notifier).getMasterpieces(
          page: 1, perPage: 15, search: null, pagination: false);
    });
    _scrollCtrl.addListener(_onScroll);
    _searchCtrl.addListener(() {
      ref.read(masterpieceControllerProvider.notifier).getMasterpieces(
          page: 1,
          perPage: 15,
          search: _searchCtrl.text.isEmpty ? null : _searchCtrl.text,
          pagination: false);
    });
  }

  void _onScroll() {
    final ctrl = ref.read(masterpieceControllerProvider.notifier);
    if (_scrollCtrl.offset >= _scrollCtrl.position.maxScrollExtent &&
        !ref.read(masterpieceControllerProvider) &&
        ctrl.masterpieces != null &&
        ctrl.total != null &&
        ctrl.masterpieces!.length < ctrl.total!) {
      _scrollLoading = true;
      _page++;
      ctrl.getMasterpieces(
          page: _page, perPage: 15, search: null, pagination: true);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(masterpieceControllerProvider);
    final ctrl = ref.watch(masterpieceControllerProvider.notifier);
    final items = ctrl.masterpieces ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('I nostri Masterpiece', style: AppTextStyle.title),
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          // search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cerca opera...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColor.borderColor),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: isLoading && !_scrollLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Text('Nessun masterpiece disponibile',
                            style: AppTextStyle.smallBody
                                .copyWith(color: Colors.grey)))
                    : RefreshIndicator(
                        onRefresh: () async {
                          _searchCtrl.clear();
                          _page = 1;
                          ref
                              .read(masterpieceControllerProvider.notifier)
                              .getMasterpieces(
                                  page: 1,
                                  perPage: 15,
                                  search: null,
                                  pagination: false);
                        },
                        child: ListView.separated(
                          controller: _scrollCtrl,
                          itemCount: items.length,
                          separatorBuilder: (_, __) => Divider(
                              height: 0,
                              indent: 16.w,
                              endIndent: 16.w,
                              color: AppColor.borderColor),
                          itemBuilder: (_, i) =>
                              _MasterpieceListTile(item: items[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _MasterpieceListTile extends StatelessWidget {
  final Masterpiece item;
  const _MasterpieceListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.masterpieceDetail,
          arguments: item),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: item.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: item.thumbnail!,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          _placeholder(70.w, Icons.image),
                    )
                  : _placeholder(70.w, Icons.image),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: AppTextStyle.normalBody
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (item.brandName != null) ...[
                    Gap(2.h),
                    Text(item.brandName!,
                        style: AppTextStyle.smallBody
                            .copyWith(color: AppColor.primaryColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                  if (item.year != null) ...[
                    Gap(2.h),
                    Text(item.year.toString(),
                        style: AppTextStyle.smallBody
                            .copyWith(color: Colors.grey)),
                  ],
                  if (item.shortDescription != null) ...[
                    Gap(4.h),
                    Text(item.shortDescription!,
                        style:
                            AppTextStyle.smallBody.copyWith(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(double size, IconData icon) => Container(
        width: size,
        height: size,
        color: Colors.grey[200],
        child: Icon(icon, color: Colors.grey[400]),
      );
}
