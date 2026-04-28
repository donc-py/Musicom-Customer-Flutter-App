// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:readypos_flutter/config/app_color.dart';
// import 'package:readypos_flutter/config/app_constants.dart';
// import 'package:readypos_flutter/config/app_text.dart';
// import 'package:readypos_flutter/controllers/pos_product_controller/product_controller.dart';
// import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';

// Future<void> barCodeScanner(
//     {required BuildContext context, required WidgetRef ref}) async {
//   String barCode = await FlutterBarcodeScanner.scanBarcode(
//     "#ffff66",
//     "Cancel",
//     true,
//     ScanMode.BARCODE,
//   );

//   if (barCode.isNotEmpty && barCode != "-1") {
//      await ref
//         .read(posProductsControllerProvider.notifier)
//         .getSearchedProducts(barCode: barCode);
//      final searchedProduct =
//         ref.read(posProductsControllerProvider.notifier).searchedProduct;

//     if (searchedProduct != null) {
//       final cartBox = Hive.box<HiveCartModel>(AppConstants.cartBox);

//       HiveCartModel cartModel = HiveCartModel(
//         id: searchedProduct.id!,
//         name: searchedProduct.name!,
//         code: searchedProduct.code!,
//         thumbnail: searchedProduct.thumbnail!,
//         subTotal: searchedProduct.subtotal!,
//         productsQTY: 1,
//       );

//       await cartBox.add(cartModel);
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text(
//           "Product successfully added to cart",
//           style: AppTextStyle.normalBody.copyWith(
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.green,
//       ));
//     } else {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           content: Text(
//             "Product not found",
//             style: AppTextStyle.normalBody.copyWith(
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: AppColor.redColor,
//         ),
//       );
//     }
//   } else {
//     // ignore: use_build_context_synchronously
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text(
//           "Process canceled",
//           style: AppTextStyle.normalBody.copyWith(
//             color: Colors.black,
//           ),
//         ),
//         // give background color warning,
//         backgroundColor: Colors.yellowAccent,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/pos_product_controller/product_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/config/app_constants.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isScanning = true;

  void _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    
    for (final barcode in barcodes) {
      if (!isScanning) return;
      
      setState(() => isScanning = false);
      
      if (barcode.rawValue == null) {
        _showErrorMessage("Barcode is empty!");
        return;
      }

      await _processBarcode(barcode.rawValue!);
    }
  }

  Future<void> _processBarcode(String barcode) async {
    try {
      await ref
          .read(posProductsControllerProvider.notifier)
          .getSearchedProducts(barCode: barcode);
          
      final searchedProduct = ref.read(posProductsControllerProvider.notifier).searchedProduct;
      
      if (searchedProduct != null) {
        final cartBox = Hive.box<HiveCartModel>(AppConstants.cartBox);
        HiveCartModel cartModel = HiveCartModel(
          id: searchedProduct.id!,
          name: searchedProduct.name!,
          code: searchedProduct.code!,
          thumbnail: searchedProduct.thumbnail!,
          subTotal: searchedProduct.subtotal!,
          productsQTY: 1,
        );
        
        await cartBox.add(cartModel);
        _showSuccessMessage("Product added to cart");
        Navigator.pop(context); // Return to POS screen
      } else {
        _showErrorMessage("Product not found");
      }
    } catch (e) {
      _showErrorMessage("Error processing barcode: ${e.toString()}");
    } finally {
      setState(() => isScanning = true);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: AppColor.redColor,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: _onDetect,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}