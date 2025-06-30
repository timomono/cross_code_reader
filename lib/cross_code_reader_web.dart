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
  final List<String> _elementIds = [];
  List<Html5QrCode> _html5Qrcodes = [];
  static final waitScriptLoading = Completer<void>();

  WebQrScannerController(super.crossCodeScannerController);

  void _registerElementId(String id) {
    _elementIds.add(id);
    if (super.crossCodeScannerController.isRunning) {
      start();
    }
  }

  void unregisterElementId(String id) => _elementIds.remove(id);

  Future<void> _start() async {
    await waitScriptLoading.future;
    print(
      "callback: ${super.crossCodeScannerController.callback} ${super.crossCodeScannerController.cameraId}",
    );
    final startRes =
        (Html5QrCode(_elementIds[0]).start(
          super.crossCodeScannerController.cameraId!.toJS,
          Html5QrcodeCameraScanConfig(fps: 10.toJS),
          SuccessCallbackWrapper(
            super.crossCodeScannerController.callback!,
          ).successCallback.toJS,
          // TODO: allowInterop is deprecated, migrate to JSExport
          // allowInterop(callback),
        )).toDart;
    print((
      super.crossCodeScannerController.cameraId!.toJS,
      Html5QrcodeCameraScanConfig(fps: 10.toJS),
      SuccessCallbackWrapper(
        super.crossCodeScannerController.callback!,
      ).successCallback.toJS,
      // TODO: allowInterop is deprecated, migrate to JSExport
      // allowInterop(callback),
    ));
    print(startRes);
    print(await startRes);
    print("ggo");
    _html5Qrcodes = await Future.wait(
      _elementIds.map((elementId) async {
        final qrScanner = Html5QrCode(elementId);
        await (qrScanner
            .start(
              super.crossCodeScannerController.cameraId!.toJS,
              Html5QrcodeCameraScanConfig(fps: 10.toJS),
              SuccessCallbackWrapper(
                super.crossCodeScannerController.callback!,
              ).successCallback.toJS,
              // TODO: allowInterop is deprecated, migrate to JSExport
              // allowInterop(callback),
            )
            .toDart);
        return qrScanner;
      }).toList(),
    );
    print("finish");
  }

  @override
  Future<void> start() async {
    try {
      await _start();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

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
  final viewId = 'cross-code-reader';
  final id = _generateId();

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
      print(!WebQrScannerController.waitScriptLoading.isCompleted);
      if (!WebQrScannerController.waitScriptLoading.isCompleted) {
        WebQrScannerController.waitScriptLoading.complete();
        print("complete");
      }
    }

    // Add div element to html
    platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final div =
          HTMLDivElement()
            ..id = id
            ..style.height = '100%'
            ..style.width = '100%';
      return div;
    });
    // TODO: Start may run before render HtmlElementView
    widget.controller._registerElementId(id);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.unregisterElementId(id);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewId);
  }

  static String _generateId() {
    const length = 20;
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return "cross-code-reader-widget-${Iterable.generate(length, (_) => chars[Random().nextInt(chars.length)]).join("")}";
  }
}
