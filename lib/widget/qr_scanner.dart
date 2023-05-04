import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'qr_scanner_overlay.dart';

class QrScanner extends StatefulWidget {
  final void Function(
      BarcodeCapture barcodesm, MobileScannerController controller) onDetect;
  const QrScanner({super.key, required this.onDetect});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  late MobileScannerController controller;
  @override
  void initState() {
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: true,
      formats: [BarcodeFormat.all],
      detectionTimeoutMs: 10000,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (ctx, con) {
        return Stack(
          children: [
            MobileScanner(
              controller: controller,
              onDetect: (barcodes) {
                widget.onDetect(barcodes, controller);
              },
            ),
            QRScannerOverlay(
              overlayColour: Colors.black.withOpacity(0.5),
            )
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
