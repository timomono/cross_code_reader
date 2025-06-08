import 'dart:ui_web';
import 'package:cross_file/cross_file.dart';
import 'package:web/web.dart';
import 'package:flutter/widgets.dart';
import 'dart:js_interop';

import 'jsTypes/basics.dart';

class WebQrScanner extends StatefulWidget {
  final String text;

  const WebQrScanner({super.key, required this.text});

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
      document.head!.appendChild(
        HTMLScriptElement()
          ..id = "html5-qrcode"
          ..src =
              "/assets/packages/cross_code_reader/assets/js/html5-qrcode.min.js"
          ..type = "application/javascript",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewId = 'cross-code-reader-${widget.text.hashCode}';

    platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final div =
          HTMLDivElement()
            ..textContent = widget.text
            ..style.fontSize = '24px'
            ..style.padding = '12px'
            ..style.border = '1px solid gray'
            ..style.backgroundColor = 'lime'
            ..style.borderRadius = '8px'
            ..style.height = '100%'
            ..style.width = '100%';
      return div;
    });

    return HtmlElementView(viewType: viewId);
  }
}
