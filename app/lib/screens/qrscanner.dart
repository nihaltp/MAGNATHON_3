import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:magnathon/database/admin_database.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:magnathon/widgets/scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  final TextEditingController _coasterIDNumberController = TextEditingController();

  Rect? scanWindowRect;

  Future<void> gameStart(int coasterID, String userID, String adminID) async {
    await DatabaseMethods().startGame(coasterID, userID, adminID);
    if(mounted) Navigator.of(context).pop();
  }

  void _qrDataFound(String data) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
        builder: (context) {return Padding(
          padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          height: 20.h,
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
              TextField(
                controller: _coasterIDNumberController,
                decoration: InputDecoration(
                  labelText: "Coaster ID Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
              SizedBox(height: 1.h,),
              TextButton(
                onPressed: () {
                  gameStart(int.parse(_coasterIDNumberController.text), data, Provider.of<StateManagement>(context, listen: false).docID);
                  Navigator.of(context).pop();
                }, 
                child: Text("Start", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),))
            ],
          ),
      )
        );
      }
    );
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
                  Navigator.of(context).pop();
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
