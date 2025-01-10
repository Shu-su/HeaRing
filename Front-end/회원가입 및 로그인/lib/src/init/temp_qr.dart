import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';


class BarcodeScanExample extends StatefulWidget {
  @override
  _BarcodeScanExampleState createState() => _BarcodeScanExampleState();
}

class _BarcodeScanExampleState extends State<BarcodeScanExample> {
  String barcode = "";

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent;
      });
    } catch (e) {
      setState(() {
        barcode = "Failed to get barcode: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan Barcode'),
            ),
            SizedBox(height: 20),
            Text(
              barcode.isEmpty ? 'Scan a code' : 'Scanned code: $barcode',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
