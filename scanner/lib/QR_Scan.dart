import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrkey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          flex: 5,
          child: QRView(
            key: qrkey,
            onQRViewCreated: _onQrViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: (result != null)
                ? Text("Barcode Data: ${result!.code}")
                : const Text("Scan a Code"),
          ),
        )
      ]),
    );
  }

  void _onQrViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _launchInBrowser(result!.code.toString());
      });
    });
  }

  void _launchInBrowser(String string) async {
    await launchUrl(Uri.parse(string));
  }
}
