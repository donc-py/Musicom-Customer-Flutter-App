import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/config/app_text.dart';

class TextFieldHeader extends ConsumerWidget {
  const TextFieldHeader(
      {super.key, required this.text, this.isRequired = true});
  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
        isRequired
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.w,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
