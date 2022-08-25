import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class FileUtil {
  Future<List<List>> getCsvFileData() async {
    try {
      Uint8List? fileData = await openFile();
      if (fileData == null) return [];
      return loadData(fileData);
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<Uint8List?> openFile() async {
    try {
      FilePickerResult? paths = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["csv"],
      );

      if (paths == null || paths.files.isEmpty) return null;
      return paths.files[0].bytes;
    } on PlatformException catch (e) {
      log("Unsupported operation$e");
    } catch (ex) {
      log(ex.toString());
    }
    return null;
  }

  List<List<dynamic>> loadData(Uint8List? fileData) {
    if (fileData == null) return [];

    final rawData = const Utf8Decoder().convert(fileData.toList());

    return const CsvToListConverter().convert(rawData);
  }
}
