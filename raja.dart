import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(QRApp());

class QRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Railway QR Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QRScannerScreen(),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // Dummy database (can replace with Firebase)
  final Map<String, Map<String, String>> database = {
    "QR001": {
      "Vendor": "ABC Steel Ltd",
      "SupplyDate": "10-08-2025",
      "Warranty": "3 Years",
      "Inspection": "Passed"
    },
    "QR002": {
      "Vendor": "XYZ Rail Pads",
      "SupplyDate": "05-09-2025",
      "Warranty": "2 Years",
      "Inspection": "Pending"
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Railway QR Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: (result != null)
                  ? _buildResultCard(result!.code!)
                  : Text('Scan a QR Code to see details'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultCard(String code) {
    var details = database[code];
    if (details == null) {
      return Text("No data found for $code");
    }
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Vendor: ${details['Vendor']}", style: TextStyle(fontSize: 18)),
            Text("Supply Date: ${details['SupplyDate']}"),
            Text("Warranty: ${details['Warranty']}"),
            Text("Inspection: ${details['Inspection']}"),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
