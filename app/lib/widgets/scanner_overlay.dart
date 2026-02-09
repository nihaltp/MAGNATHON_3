import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;

  ScannerOverlayPainter(this.scanWindow);

  @override
  void paint(Canvas canvas, Size size) {
    final overlayColor = Paint()
      ..color = Colors.black.withOpacity(0.6);

    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;

    final fullScreen = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.saveLayer(fullScreen, Paint());
    canvas.drawRect(fullScreen, overlayColor);

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)),
      clearPaint,
    );

    canvas.restore();

    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
