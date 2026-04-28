import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/event_controller/event_controller.dart';
import 'package:readypos_flutter/models/event/event.dart';
import 'package:readypos_flutter/routes.dart';

class EventsListView extends ConsumerStatefulWidget {
  const EventsListView({super.key});

  @override
  ConsumerState<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends ConsumerState<EventsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(eventControllerProvider.notifier)
          .getEvents(page: 1, perPage: 20, search: null, pagination: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(eventControllerProvider);
    final items = ref.watch(eventControllerProvider.notifier).events ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Eventi', style: AppTextStyle.title),
        surfaceTintColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Text('Nessun evento disponibile',
                      style:
                          AppTextStyle.smallBody.copyWith(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: () async {
                    ref.read(eventControllerProvider.notifier).getEvents(
                        page: 1, perPage: 20, search: null, pagination: false);
                  },
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 0,
                        indent: 16.w,
                        endIndent: 16.w,
                        color: AppColor.borderColor),
                    itemBuilder: (_, i) => _EventListTile(event: items[i]),
                  ),
                ),
    );
  }
}

class _EventListTile extends StatelessWidget {
  final Event event;
  const _EventListTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMMM yyyy').format(event.startsAt);
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, Routes.eventDetail, arguments: event),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: event.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: event.thumbnail!,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateStr,
                      style: AppTextStyle.smallBody.copyWith(
                          color: AppColor.primaryColor, fontSize: 11.sp)),
                  Gap(4.h),
                  Text(event.title,
                      style: AppTextStyle.normalBody
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (event.location != null) ...[
                    Gap(4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12.r, color: Colors.grey),
                        Gap(2.w),
                        Expanded(
                          child: Text(event.location!,
                              style: AppTextStyle.smallBody
                                  .copyWith(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
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

  Widget _placeholder() => Container(
      width: 80.w,
      height: 80.w,
      color: Colors.grey[200],
      child: Icon(Icons.event, color: Colors.grey[400]));
}
