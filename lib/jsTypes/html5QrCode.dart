import 'dart:js_interop';

import 'basics.dart';

typedef QrcodeSuccessCallback =
    void Function(String decodedText, Html5QrcodeResult result);

typedef QrcodeErrorCallback =
    void Function(String errorMessage, Html5QrcodeError error);

enum Html5QrcodeErrorTypes {
  UNKWOWN_ERROR,
  IMPLEMENTATION_ERROR,
  NO_CODE_FOUND_ERROR,
}

class Html5QrcodeError implements Exception {
  final String errorMessage;
  final Html5QrcodeErrorTypes type;

  Html5QrcodeError({required this.errorMessage, required this.type});

  @override
  String toString() => "[$type] $errorMessage";
}

class Html5QrcodeResult {
  final String decodedText;
  final QrcodeResult result;

  Html5QrcodeResult({required this.decodedText, required this.result});
}

class QrBounds extends QrDimensions {
  final int x;
  final int y;

  const QrBounds(super.width, super.height, this.x, this.y);
}

class QrcodeResult {
  QrcodeResult._internal({
    required this.text,
    this.format,
    this.bounds,
    this.decodedTextType,
    this.debugData,
  });

  /// Decoded text.
  String text;

  /// Format that was successfully scanned.
  QrcodeResultFormat? format;

  /// The bounds of the decoded QR code or bar code in the whole stream of
  /// image.
  ///
  /// Note: this is experimental, and not fully supported.
  QrBounds? bounds;

  /// If the decoded text from the QR code or bar code is of a known type like
  /// url or upi id or email id.
  ///
  /// Note: this is experimental, and not fully supported.
  DecodedTextType? decodedTextType;

  /// Data class for QR code result used for debugging.
  QrcodeResultDebugData? debugData;
}

/// Data class for QR code result used for debugging.
class QrcodeResultDebugData {
  /// Name of the decoder that was used for decoding.
  String? decoderName;
}

enum DecodedTextType { UNKNOWN, URL }

enum Html5QrcodeSupportedFormats {
  QR_CODE,
  AZTEC,
  CODABAR,
  CODE_39,
  CODE_93,
  CODE_128,
  DATA_MATRIX,
  MAXICODE,
  ITF,
  EAN_13,
  EAN_8,
  PDF_417,
  RSS_14,
  RSS_EXPANDED,
  UPC_A,
  UPC_E,
  UPC_EAN_EXTENSION,
}

/// Format of detected code.
class QrcodeResultFormat {
  final Html5QrcodeSupportedFormats format;
  final String formatName;

  const QrcodeResultFormat._internal(this.format, this.formatName);

  @override
  String toString() {
    return formatName;
  }

  // QrcodeResultFormat create(Html5QrcodeSupportedFormats format) {
  //   if (!html5QrcodeSupportedFormatsTextMap.has(format)) {
  //     throw "${format} not in html5QrcodeSupportedFormatsTextMap";
  //   }
  //   return new QrcodeResultFormat(
  //     format, html5QrcodeSupportedFormatsTextMap.get(format)!);
  // }
}

/// String or MediaTrackConstraints
sealed class CameraIdOrConfig {
  const CameraIdOrConfig._internal(this.value);
  final dynamic value;

  const factory CameraIdOrConfig.string(String value) = _CameraIdOrConfigString;
  const factory CameraIdOrConfig.mediaTrackConstraints(
    MediaTrackConstraints value,
  ) = _CameraIdOrConfigMediaTrackConstraints;
}

class _CameraIdOrConfigString extends CameraIdOrConfig {
  const _CameraIdOrConfigString(super.value) : super._internal();

  @override
  String get value => super.value;
}

class _CameraIdOrConfigMediaTrackConstraints extends CameraIdOrConfig {
  const _CameraIdOrConfigMediaTrackConstraints(super.value) : super._internal();

  @override
  MediaTrackConstraints get value => super.value;
}

class QrDimensions {
  const QrDimensions(this.width, this.height);

  final num width;
  final num height;
}

/// number or QrDimensions or QrDimensionFunction
sealed class QrBox {
  const QrBox._internal(this.value);

  final dynamic value;

  const factory QrBox.number(_QrBoxNumber value) = _QrBoxNumber;
  const factory QrBox.qrDimensions(_QrBoxQrDimensions value) =
      _QrBoxQrDimensions;
  // TODO: Support QrDimensionsFunction
  // const factory QrBox.qrDimensionsFunction(MediaTrackConstraints value) =
  //     _CameraIdOrConfigMediaTrackConstraints;
}

class _QrBoxNumber extends QrBox {
  const _QrBoxNumber(super.value) : super._internal();

  @override
  num get value => super.value;
}

class _QrBoxQrDimensions extends QrBox {
  const _QrBoxQrDimensions(super.value) : super._internal();

  @override
  QrDimensions get value => super.value;
}

extension type Html5QrcodeCameraScanConfig._(JSObject _) implements JSObject {
  external num? aspectRatio;
  external bool? disableFlip;
  external num? fps;
  external QrBox? qrbox;
  external MediaTrackConstraints? videoConstraints;
}

@JS("html5QrCode")
@staticInterop
extension type HTML5QrCode._(JSObject _) implements JSObject {
  @JS("html5QrCode.start")
  external JSPromise<Undefined> start(
    CameraIdOrConfig cameraIdOrConfig,
    Html5QrcodeCameraScanConfig? configuration,
    // TODO: QrC <= should this big letter?
    QrcodeSuccessCallback qrCodeSuccessCallback,
  );

  @JS("html5QrCode.stop")
  external JSPromise<Undefined> stop();
}
