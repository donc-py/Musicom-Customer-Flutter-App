import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:printing/printing.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';

class PDFViewScreen extends ConsumerStatefulWidget {
  const PDFViewScreen({required this.url, super.key});
  final String url;

  @override
  ConsumerState<PDFViewScreen> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<PDFViewScreen> {
  Uint8List? data;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text('Invoice'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PdfPreview(
              canChangeOrientation: false,
              allowPrinting: true,
              canDebug: false,
              canChangePageFormat: true,
              actionBarTheme: const PdfActionBarTheme(
                backgroundColor: AppColor.primaryColor,
              ),
              build: (format) => data!,
            ),
    );
  }

  Future<Uint8List?> downloadFile() async {
    final authBox = Hive.box(AppConstants.authBox);
    final token = authBox.get(AppConstants.authToken);
    final dio = Dio();
    try {
      Response response = await dio.get(
        widget.url,
        options: Options(
            headers: {"Authorization": "Bearer $token"},
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      return response.data;
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    data = await downloadFile();
    setState(() {
      isLoading = false;
    });
  }
}
