import 'package:test/test.dart';

import 'package:one_time_pad/one_time_pad.dart';

void main() {
  group('OtpEncoder', () {
    test('.convert() properly encrypts a message', () {
      var encoder = OtpEncoder.fromList([1, 2, 3, 4]);
      expect(encoder.convert('abc!'), equals('bdf!'));
    });
    test('can be used to transform a Stream<String>', () async {
      var encoder = OtpEncoder.fromList([1, 2, 3, 4]);
      var stream = Stream<String>.fromIterable(['abc!', 'def']);
      expect(await stream.transform(encoder).toList(), equals(['bdf!', 'egi']));
    });
  });
  group('OtpDecoder', () {
    test('.convert() properly decrypts a message', () {
      var decoder = OtpDecoder.fromList([1, 2, 3, 4]);
      expect(decoder.convert('bdf!'), equals('abc!'));
    });
    test('can be used to transform a Stream<String>', () async {
      var decoder = OtpDecoder.fromList([1, 2, 3, 4]);
      var stream = Stream<String>.fromIterable(['bdf!', 'egi']);
      expect(await stream.transform(decoder).toList(), equals(['abc!', 'def']));
    });
  });
}
