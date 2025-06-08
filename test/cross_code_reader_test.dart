// import 'package:flutter_test/flutter_test.dart';
// import 'package:cross_code_reader/cross_code_reader.dart';
// import 'package:cross_code_reader/cross_code_reader_platform_interface.dart';
// import 'package:cross_code_reader/cross_code_reader_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockCrossCodeReaderPlatform
//     with MockPlatformInterfaceMixin
//     implements CrossCodeReaderPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final CrossCodeReaderPlatform initialPlatform = CrossCodeReaderPlatform.instance;
//
//   test('$MethodChannelCrossCodeReader is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelCrossCodeReader>());
//   });
//
//   test('getPlatformVersion', () async {
//     CrossCodeReader crossCodeReaderPlugin = CrossCodeReader();
//     MockCrossCodeReaderPlatform fakePlatform = MockCrossCodeReaderPlatform();
//     CrossCodeReaderPlatform.instance = fakePlatform;
//
//     expect(await crossCodeReaderPlugin.getPlatformVersion(), '42');
//   });
// }
