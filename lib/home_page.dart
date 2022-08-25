import 'dart:developer';

import 'package:csv_order_parser/file_util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';

  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  var data = await FileUtil().getCsvFileData();
                  for (var element in data) {
                    log(element.toString());
                  }
                },
                child: const Text('Load CSV File'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
