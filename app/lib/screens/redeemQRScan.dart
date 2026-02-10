import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:magnathon/database/admin_database.dart';
import 'package:magnathon/screens/point_redeem.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:magnathon/widgets/scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RedeemQRScannerScreen extends StatefulWidget {
  const RedeemQRScannerScreen({super.key});

  @override
  State<RedeemQRScannerScreen> createState() => _RedeemQRScannerScreenState();
}

class _RedeemQRScannerScreenState extends State<RedeemQRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();


  Rect? scanWindowRect;

  Future<void> _qrDataFound(String data) async {
    Map<String, dynamic> result = await DatabaseMethods().getUserDetails(data);
    if(mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RedemptionScreen(userName: result["name"], userPoints: result["remainingPoints"], userID: data,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final boxSize = screenWidth * 0.7;

          final left = (screenWidth - boxSize) / 2;
          final top = (screenHeight - boxSize) / 2;

          scanWindowRect = Rect.fromLTWH(left, top, boxSize, boxSize);

          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                scanWindow: scanWindowRect,
                onDetect: (BarcodeCapture capture) {
                  controller.dispose();
                  log(capture.barcodes.first.rawValue!);
                  _qrDataFound(capture.barcodes.first.rawValue!);
                  // Navigator.of(context).pop();
                  // for (final barcode in capture.barcodes) {
                  //   if (barcode.corners.isEmpty) continue;

                  //   final corners = barcode.corners;

                  //   final minX = corners.map((e) => e.dx).reduce((a, b) => a < b ? a : b);
                  //   final maxX = corners.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
                  //   final minY = corners.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
                  //   final maxY = corners.map((e) => e.dy).reduce((a, b) => a > b ? a : b);

                  //   final imageSize = capture.size;

                  //   final scaleX = screenWidth / imageSize.width;
                  //   final scaleY = screenHeight / imageSize.height;


                  //   final barcodeRect = Rect.fromLTRB(
                  //     minX * scaleX,
                  //     minY * scaleY,
                  //     maxX * scaleX,
                  //     maxY * scaleY,
                  //   );

                  //   if (scanWindowRect!.overlaps(barcodeRect)) {
                  //     log("QR Found: ${barcode.rawValue}");
                  //     // Navigator.of(context).pop();
                  //   }
                  // }
                },
              ),
              CustomPaint(
                size: Size(screenWidth, screenHeight),
                painter: ScannerOverlayPainter(scanWindowRect!),
              ),
            ],
          );
        },
      ),
    );
  }
}
