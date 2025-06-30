import 'package:flutter/material.dart';
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
  final controller = CrossCodeScannerController();

  @override
  void initState() {
    super.initState();
    (() async {
      // print((await Camera.getCameras())[0].id);
      // Future.delayed(
      //   Duration(seconds: 5),
      // await (controller..callback = ((text, _) => print(text))).start();
      controller.callback = (text, _) => print(text);
      await controller.start();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CrossCodeScanner(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
