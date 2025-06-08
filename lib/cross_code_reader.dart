import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'cross_code_reader_web.dart';

class NativeView extends StatelessWidget {
  final String text;

  const NativeView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    const viewType = 'native-view';
    final creationParams = {'text': text};

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (kIsWeb) {
      return WebQrScanner(text: text); // Web用Widget
    } else {
      return Text('Unsupported platform');
    }
  }
}
