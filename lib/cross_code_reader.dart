import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart';

import 'cross_code_reader_web.dart';
import 'jsTypes/html5_qrcode.dart';

typedef SuccessCallback =
    void Function(String decodedText, Html5QrcodeResult result);

// TODO: Update all names to 'scanner'
class CrossCodeScannerController {
  late final PlatformCrossCodeScannerController platformController;
  SuccessCallback? callback;
  CameraId? cameraId;
  bool isRunning = false;

  CrossCodeScannerController({this.cameraId, this.callback}) {
    if (kIsWeb) {
      platformController = WebQrScannerController(this);
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

  /// Run qr code scanner on the this.cameraId
  Future<void> start() async {
    if (isRunning) return;
    callback ??= (_, _) {};
    cameraId ??= (await Camera.getCameras())[0].id;
    await platformController.start();
  }

  Future<void> stop(CameraId cameraId) async {
    if (!isRunning) return;
    await platformController.stop();
  }
}

abstract class PlatformCrossCodeScannerController {
  const PlatformCrossCodeScannerController(this.crossCodeScannerController);

  final CrossCodeScannerController crossCodeScannerController;
  Future<void> start();
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
  static final Completer<void> _scriptLoadCompleter = Completer();

  static Future<void> _loadScript() {
    if (document.querySelectorAll("#html5-qrcode").length == 0) {
      // TODO: What is the difference between "append"?
      final scriptElement =
          HTMLScriptElement()
            ..id = "html5-qrcode"
            ..src =
                "/assets/packages/cross_code_reader/assets/js/html5-qrcode.min.js"
            ..type = "application/javascript"
            ..onLoad.listen(
              (e) =>
                  _scriptLoadCompleter.isCompleted
                      ? null
                      : _scriptLoadCompleter.complete(),
            );
      document.head!.appendChild(scriptElement);
    } else {
      if (!_scriptLoadCompleter.isCompleted) {
        _scriptLoadCompleter.complete();
      }
    }
    return _scriptLoadCompleter.future;
  }

  static Future<List<Camera>> getCameras() async {
    if (kIsWeb) {
      await _loadScript();
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
