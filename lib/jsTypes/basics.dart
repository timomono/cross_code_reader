import 'dart:js_interop';

@JS("undefined")
@staticInterop
extension type Undefined._(JSObject _) implements JSObject {}

@JS()
@staticInterop
@anonymous
class MediaTrackConstraints {
  external factory MediaTrackConstraints({String? deviceId, String? groupId});
}

extension MediaTrackConstraintsExt on MediaTrackConstraints {
  external String? get deviceId;

  external String? get groupId;
  external set groupId(String? value);
}

@JS()
@staticInterop
@anonymous
class AudioTrackConstraints implements MediaTrackConstraints {
  external factory AudioTrackConstraints({
    String? deviceId,
    String? groupId,
    bool? autoGainControl,
    bool? echoCancellation,
    bool? noiseSuppression,
    num? sampleRate,
    num? sampleSize,
    num? latency,
    num? channelCount,
  });
}

extension AudioTrackConstraintsExt on AudioTrackConstraints {
  external bool? get autoGainControl;
  external set autoGainControl(bool? value);

  external bool? get echoCancellation;
  external set echoCancellation(bool? value);

  external bool? get noiseSuppression;
  external set noiseSuppression(bool? value);

  external num? get sampleRate;
  external set sampleRate(num? value);

  external num? get sampleSize;
  external set sampleSize(num? value);

  external num? get latency;
  external set latency(num? value);

  external num? get channelCount;
  external set channelCount(num? value);
}
