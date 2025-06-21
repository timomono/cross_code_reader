import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'cross_code_reader_web.dart';
import 'jsTypes/html5_qrcode.dart';

typedef SuccessCallback =
    void Function(String decodedText, Html5QrcodeResult result);

// TODO: Update all names to 'scanner'
class CrossCodeScannerController {
  late final PlatformCrossCodeScannerController platformController;
  bool isRunning = false;

  CrossCodeScannerController() {
    if (kIsWeb) {
      platformController = WebQrScannerController();
      return;
    }
    throw UnsupportedError("Unsupported platform");
    // switch (defaultTargetPlatform) {
    //   case TargetPlatform.android:
    //     this.platformController = AndroidQrScannerController();
    //     break;
    //   case TargetPlatform.iOS:
    //     this.platformController = IOSQrScannerController();
    // }
  }

  Future<void> start(CameraId cameraId, SuccessCallback callback) async {
    if (isRunning) return;
    await platformController.start(cameraId, callback);
  }

  Future<void> stop(CameraId cameraId) async {
    if (!isRunning) return;
    await platformController.stop();
  }
}

abstract class PlatformCrossCodeScannerController {
  Future<void> start(CameraId cameraId, SuccessCallback callback);
  Future<void> stop();
}

class CrossCodeScanner extends StatelessWidget {
  final CrossCodeScannerController controller;

  const CrossCodeScanner({super.key, required this.controller});

  // static getCameras() {
  //
  // }

  @override
  Widget build(BuildContext context) {
    // const viewType = 'cross-code-reader';
    // final creationParams = {'text': text};

    if (kIsWeb) {
      return WebQrScanner(
        controller: controller.platformController as WebQrScannerController,
      );
    } else {
      throw UnsupportedError("Unsupported platform");
    }
    // else if (defaultTargetPlatform == TargetPlatform.android) {
    //   return AndroidView(
    //     viewType: viewType,
    //     // creationParams: creationParams,
    //     creationParamsCodec: const StandardMessageCodec(),
    //   );
    // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   return UiKitView(
    //     viewType: viewType,
    //     // creationParams: creationParams,
    //     creationParamsCodec: const StandardMessageCodec(),
    //   );
    // } else {
    //   throw UnsupportedError("Unsupported platform");
    //   // return Text('Unsupported platform');
    // }
  }
}

class Camera {
  const Camera({required this.id, required this.label});

  final CameraId id;
  final String label;

  static Future<List<Camera>> getCameras() async {
    if (kIsWeb) {
      return (await Html5QrCode.getCameras().toDart).toDart
          .map(
            (e) => Camera(id: e.id.toDart as CameraId, label: e.label.toDart),
          )
          .toList();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}

extension type CameraId(String value) implements String {}
