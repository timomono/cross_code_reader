import 'dart:async';
import 'dart:math';
import 'dart:ui_web';
import 'package:cross_code_reader/cross_code_reader.dart';
import 'package:cross_code_reader/jsTypes/html5_qrcode.dart';
import 'package:web/web.dart';
import 'package:flutter/widgets.dart';
import 'dart:js_interop';
// import 'dart:js';
// import 'package:js/js_util.dart';
// allowInterop: deprecated

class SuccessCallbackWrapper {
  const SuccessCallbackWrapper(this.callback);
  final SuccessCallback callback;
  @JSExport()
  void successCallback(JSString decodedText, Html5QrcodeResult result) =>
      callback(decodedText.toDart, result);
}

class WebQrScannerController extends PlatformCrossCodeScannerController {
  List<String> elementIds = [];
  List<Html5QrCode> html5Qrcodes = [];
  static final waitScriptLoading = Completer<void>();
  @override
  Future<void> start(
    CameraId cameraId,
    SuccessCallback callback,
  ) async => WidgetsBinding.instance.addPostFrameCallback(
    (_) => waitScriptLoading.future.then<void>(
      (_) =>
          html5Qrcodes =
              elementIds
                  .map(
                    (elementId) => Html5QrCode(elementId)..start(
                      cameraId.toJS,
                      Html5QrcodeCameraScanConfig(fps: 10.toJS),
                      SuccessCallbackWrapper(callback).successCallback.toJS,
                      // TODO: allowInterop is deprecated, migrate to JSExport
                      // allowInterop(callback),
                    ),
                  )
                  .toList(),
    ),
  );

  @override
  Future<void> stop() {
    // TODO: implement stop
    throw UnimplementedError();
  }
}

class WebQrScanner extends StatefulWidget {
  const WebQrScanner({super.key, required this.controller});

  final WebQrScannerController controller;

  @override
  State<WebQrScanner> createState() => _WebQrScannerState();
}

class _WebQrScannerState extends State<WebQrScanner> {
  @override
  void initState() {
    super.initState();
    // CDN: Does not work offline
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
                  WebQrScannerController.waitScriptLoading.isCompleted
                      ? null
                      : WebQrScannerController.waitScriptLoading.complete(),
            );
      document.head!.appendChild(scriptElement);
    } else {
      if (!WebQrScannerController.waitScriptLoading.isCompleted) {
        WebQrScannerController.waitScriptLoading.complete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewId = 'cross-code-reader';

    platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final id = generateId();
      widget.controller.elementIds.add(id);
      final div =
          HTMLDivElement()
            ..id = id
            ..style.height = '100%'
            ..style.width = '100%';
      return div;
    });

    return HtmlElementView(viewType: viewId);
  }

  String generateId() {
    const length = 20;
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return "cross-code-reader-widget-${Iterable.generate(length, (_) => chars[Random().nextInt(chars.length)]).join("")}";
  }
}
