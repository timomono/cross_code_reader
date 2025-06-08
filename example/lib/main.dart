import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:cross_code_reader/cross_code_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 100, width: 100, child: NativeView(text: 'emm')),

            SizedBox(height: 100, width: 100, child: NativeView(text: 'faa')),

            SizedBox(height: 100, width: 100, child: NativeView(text: 'emm')),
          ],
        ),
      ),
    );
  }
}
