import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';

  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fileName = '';
  List<List<dynamic>> orders = [];
  Map<String, double> avarageMap = {};
  Map<String, String> brandMap = {};
  TextStyle linkeTextStyle = const TextStyle(color: Colors.blue, decoration: TextDecoration.underline);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem solving case'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  avarageMap = {};
                  brandMap = {};
                  PlatformFile? csvFile = await pickFile();
                  if (csvFile == null) return;
                  fileName = csvFile.name;
                  orders = loadCsvData(csvFile.bytes);
                  if (orders.isEmpty || orders.length > 10 ^ 4) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('number of rows of data must be >= 1 and <= 10^4'),
                      ),
                    );
                  }

                  calc();
                  setState(() {});
                },
                child: const Text('Load CSV File'),
              ),
            ),
            const SizedBox(height: 24),
            if (avarageMap.isNotEmpty)
              Row(
                children: [
                  const Text('average quantity of the product :'),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: _downLoad0_file,
                    child: Text('download 0_$fileName', style: linkeTextStyle),
                  ),
                ],
              ),
            ...avarageMap.keys.map((key) => Text('$key , ${avarageMap[key]}')).toList(),
            const SizedBox(height: 24),
            if (brandMap.isNotEmpty)
              Row(
                children: [
                  const Text('most popular Brand : '),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: _downLoad1_file,
                    child: Text('download 1_$fileName', style: linkeTextStyle),
                  ),
                ],
              ),
            ...brandMap.keys.map((key) => Text('$key , ${brandMap[key]}')).toList(),
          ],
        ),
      ),
    );
  }

  void calc() {
    ///map structure
    /// {productName:{BrandName : quantity}}
    Map<String, Map<String, QuantityModel>> ordersMap = {};
    // claculate product quantity and brand count
    for (var element in orders) {
      if (element.length == 5) {
        String productName = element[2] ?? '';
        int quantity = element[3] ?? 0;
        String brandName = element[4] ?? '';
        // check data validity
        if (productName.isNotEmpty && brandName.isNotEmpty && quantity > 0) {
          if (!ordersMap.containsKey(productName)) ordersMap[productName] = {};
          if (!ordersMap[productName]!.containsKey(brandName)) ordersMap[productName]!.addAll({brandName: QuantityModel()});
          var res = ordersMap[productName]![brandName]!;
          res.saledCount = res.saledCount + quantity;
          res.orderCount = res.orderCount + 1;
        }
      }
    }

    // get final result
    ordersMap.forEach((productName, brandName) {
      int totalQuantity = 0;
      String topSoledBrand = '';
      int orderCount = 0;
      brandName.forEach((brandName, quantityModel) {
        // get total saled Quantity
        totalQuantity += quantityModel.saledCount;

        // calculate top brand
        if (quantityModel.orderCount > orderCount) {
          topSoledBrand = brandName;
          orderCount = quantityModel.orderCount;
        }
      });
      avarageMap[productName] = totalQuantity / orders.length;
      brandMap[productName] = topSoledBrand;
    });
  }

  Future<PlatformFile?> pickFile() async {
    try {
      FilePickerResult? paths = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["csv"],
      );

      if (paths == null || paths.files.isEmpty) return null;
      return paths.files[0];
    } catch (ex) {
      log(ex.toString());
    }
    return null;
  }

  List<List<dynamic>> loadCsvData(Uint8List? fileData) {
    if (fileData == null) return [];

    final rawData = const Utf8Decoder().convert(fileData.toList());

    return const CsvToListConverter().convert(rawData);
  }

  void _downLoad0_file() {
    List<List<dynamic>> rows = [];

    avarageMap.forEach((key, value) {
      List<dynamic> row = [];
      row.add(key);
      row.add(value);
      rows.add(row);
    });

    String csv = const ListToCsvConverter().convert(rows);
    _downloadFile(csv, '0_$fileName');
  }

  void _downLoad1_file() {
    List<List<dynamic>> rows = [];

    brandMap.forEach((key, value) {
      List<dynamic> row = [];
      row.add(key);
      row.add(value);
      rows.add(row);
    });

    String csv = const ListToCsvConverter().convert(rows);
    _downloadFile(csv, '1_$fileName');
  }

  void _downloadFile(String data, String fileName) {
    if (kIsWeb) {
      // Encode our file in base64
      final base64 = base64Encode(data.codeUnits);
      // Create the link with the file
      final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')..target = 'blank';
      // add the name

      anchor.download = fileName;

      // trigger download
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
    }
  }
}

class QuantityModel {
  int saledCount = 0;
  int orderCount = 0;
}
