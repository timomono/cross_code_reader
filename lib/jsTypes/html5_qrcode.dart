// ignore_for_file: non_constant_identifier_names
import 'dart:js_interop';
import 'package:web/web.dart';

import 'basics.dart' as basics;

// typedef QrcodeSuccessCallback =
//     void Function(String decodedText, Html5QrcodeResult result);
/// void Function(String decodedText, Html5QrcodeResult result)
typedef QrcodeSuccessCallback = JSFunction;
// typedef QrcodeErrorCallback =
//     void Function(String errorMessage, Html5QrcodeError error);

/// void Function(String errorMessage, Html5QrcodeError error);
typedef QrcodeErrorCallback = JSFunction;

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

@JS()
@anonymous
@staticInterop
class Html5QrcodeResult {
  external factory Html5QrcodeResult({
    required JSString decodedText,
    required QrcodeResult result,
  });
}

extension Html5QrcodeResultExtension on Html5QrcodeResult {
  external JSString get decodedText;
  external QrcodeResult get result;
}

@JS()
@anonymous
@staticInterop
class QrBounds extends QrDimensions {
  external factory QrBounds({
    JSNumber width,
    JSNumber height,
    JSNumber x,
    JSNumber y,
  });
}

extension QrBoundsExtension on QrBounds {
  external JSNumber get x;
  external JSNumber get y;
}

@JS()
@anonymous
@staticInterop
class QrcodeResult {
  external factory QrcodeResult({
    required JSString text,
    QrcodeResultFormat? format,
    QrBounds? bounds,
    DecodedTextType? decodedTextType,
    QrcodeResultDebugData? debugData,
  });
}

extension QrCodeResultExtension on QrcodeResult {
  /// Decoded text.
  external JSString get text;

  /// Format that was successfully scanned.
  external QrcodeResultFormat? get format;

  /// The bounds of the decoded QR code or bar code in the whole stream of
  /// image.
  ///
  /// Note: this is experimental, and not fully supported.
  external QrBounds? get bounds;

  /// If the decoded text from the QR code or bar code is of a known type like
  /// url or upi id or email id.
  ///
  /// Note: this is experimental, and not fully supported.
  external DecodedTextType? get decodedTextType;

  /// Data class for QR code result used for debugging.
  external QrcodeResultDebugData? get debugData;
}

/// Data class for QR code result used for debugging.
@JS()
@anonymous
@staticInterop
class QrcodeResultDebugData {}

extension QrcodeResultDebugDataExtension on QrcodeResultDebugData {
  /// Name of the decoder that was used for decoding.
  external JSString? decoderName;
}

// enum DecodedTextType { UNKNOWN, URL }

@JS()
@staticInterop
class DecodedTextType {
  external static int get UNKNOWN;
  external static int get URL;
}

@JS()
@staticInterop
class Html5QrcodeSupportedFormats {
  external static int get QR_CODE;
  external static int get AZTEC;
  external static int get CODABAR;
  external static int get CODE_39;
  external static int get CODE_93;
  external static int get CODE_128;
  external static int get DATA_MATRIX;
  external static int get MAXICODE;
  external static int get ITF;
  external static int get EAN_13;
  external static int get EAN_8;
  external static int get PDF_417;
  external static int get RSS_14;
  external static int get RSS_EXPANDED;
  external static int get UPC_A;
  external static int get UPC_E;
  external static int get UPC_EAN_EXTENSION;
}

/// Format of detected code.
@JS()
@anonymous
@staticInterop
class QrcodeResultFormat {}

extension QrcodeResultFormatExtension on QrcodeResultFormat {
  external Html5QrcodeSupportedFormats get format;
  external JSString get formatName;

  @JS("toString")
  external String toJsString();
  //   return formatName.toDart;
  // }

  // external const QrcodeResultFormat._internal(this.format, this.formatName);

  // QrcodeResultFormat create(Html5QrcodeSupportedFormats format) {
  //   if (!html5QrcodeSupportedFormatsTextMap.has(format)) {
  //     throw "${format} not in html5QrcodeSupportedFormatsTextMap";
  //   }
  //   return new QrcodeResultFormat(
  //     format, html5QrcodeSupportedFormatsTextMap.get(format)!);
  // }
}

/// String or MediaTrackConstraints
// sealed class CameraIdOrConfig {
//   const CameraIdOrConfig._internal(this.value);
//   final dynamic value;
//
//   const factory CameraIdOrConfig.string(String value) = _CameraIdOrConfigString;
//   const factory CameraIdOrConfig.mediaTrackConstraints(
//     MediaTrackConstraints value,
//   ) = _CameraIdOrConfigMediaTrackConstraints;
// }
//
// class _CameraIdOrConfigString extends CameraIdOrConfig {
//   const _CameraIdOrConfigString(super.value) : super._internal();
//
//   @override
//   String get value => super.value;
// }
//
// class _CameraIdOrConfigMediaTrackConstraints extends CameraIdOrConfig {
//   const _CameraIdOrConfigMediaTrackConstraints(super.value) : super._internal();
//
//   @override
//   MediaTrackConstraints get value => super.value;
// }

@JS()
@anonymous
@staticInterop
class QrDimensions {
  external factory QrDimensions({JSNumber width, JSNumber height});
}

extension QrDimensionsExtension on QrDimensions {
  external final JSNumber width;
  external final JSNumber height;
}

/// number or QrDimensions or QrDimensionFunction
// sealed class QrBox {
//   const QrBox._internal(this.value);
//
//   final dynamic value;
//
//   const factory QrBox.number(_QrBoxNumber value) = _QrBoxNumber;
//   const factory QrBox.qrDimensions(_QrBoxQrDimensions value) =
//       _QrBoxQrDimensions;
//   // TODO: Support QrDimensionsFunction
//   // const factory QrBox.qrDimensionsFunction(MediaTrackConstraints value) =
//   //     _CameraIdOrConfigMediaTrackConstraints;
// }
//
// class _QrBoxNumber extends QrBox {
//   const _QrBoxNumber(super.value) : super._internal();
//
//   @override
//   num get value => super.value;
// }
//
// class _QrBoxQrDimensions extends QrBox {
//   const _QrBoxQrDimensions(super.value) : super._internal();
//
//   @override
//   QrDimensions get value => super.value;
// }

@JS()
@anonymous
@staticInterop
class Html5QrcodeCameraScanConfig {
  external factory Html5QrcodeCameraScanConfig({
    JSNumber? aspectRatio,
    JSBoolean? disableFlip,
    JSNumber? fps,
    // QrBox? qrbox,
    /// JSNumber or QrDimensions
    JSAny? qrbox,
    MediaTrackConstraints? videoConstraints,
  });
}

extension Html5QrcodeCameraScanConfigExtension on Html5QrcodeCameraScanConfig {
  external final num? aspectRatio;
  external final bool? disableFlip;
  external final num? fps;

  /// number or QrDimensions
  external final JSAny? qrbox;
  external final MediaTrackConstraints? videoConstraints;
}

extension type CameraDevice._(JSObject _) implements JSObject {
  external final JSString id;
  external final JSString label;
}

// @JS()
// @anonymous
// @staticInterop
// class CameraDevice {
//   external factory CameraDevice({JSString? id, JSString? label});
// }
//
// extension CameraDeviceExtension on CameraDevice {
//   external final JSString? id;
//   external final JSString? label;
// }

@JS("Html5Qrcode")
@staticInterop
extension type Html5QrCode._(JSObject _) implements JSObject {
  external Html5QrCode(
    String elementId,
    // (boolean | Html5QrcodeFullConfig)? configOrVerbosityFlag
  );

  // @JS("html5QrCode.start")
  external JSPromise<basics.Undefined> start(
    /// MediaTrackConstraints or String
    JSAny cameraIdOrConfig, [
    // TODO: QrC <= should this big letter?
    // It can be undefined, but an
    // error occurred when it was undefined
    Html5QrcodeCameraScanConfig configuration,
    QrcodeSuccessCallback qrCodeSuccessCallback,
    QrcodeErrorCallback? qrCodeErrorCallback,
  ]);

  // @JS("html5QrCode.stop")
  external JSPromise<basics.Undefined> stop();

  external static JSPromise<JSArray<CameraDevice>> getCameras();
}
