import 'dart:convert';
import 'dart:typed_data';

import './extensions.dart';
import '../one_time_pad.dart';

/// This class encrypts messages using the one-time pad system
class OtpEncoder extends Converter<String, String> {
  final Uint8List _otp;

  /// Create a transformer using [otp]
  OtpEncoder(Uint8List otp) : _otp = otp;

  /// Create a transformer from list [otp]
  OtpEncoder.fromList(List<int> otp) : _otp = Uint8List.fromList(otp);
  @override
  String convert(String input) {
    var returnVal = '';
    for (var i = 0; i < input.length; ++i) {
      if (input[i].isAlpha) {
        var magicNumber =
            input[i].isLowerCaseAlpha ? 'a'.codeUnitAt(0) : 'A'.codeUnitAt(0);
        var currentIndex = input.codeUnitAt(i) - magicNumber;
        returnVal +=
            String.fromCharCode((currentIndex + _otp[i]) % 26 + magicNumber);
      } else {
        returnVal += input[i];
      }
    }
    return returnVal;
  }

  @override
  Sink<String> startChunkedConversion(Sink<String> sink) {
    return StringEventConverterSink(sink, this);
  }
}

/// This class decrypts messages using the one-time pad system
class OtpDecoder extends Converter<String, String> {
  final Uint8List _otp;

  /// Create a transformer using [otp]
  OtpDecoder(Uint8List otp) : _otp = otp;

  /// Create a transformer from list [otp]
  OtpDecoder.fromList(List<int> otp) : _otp = Uint8List.fromList(otp);
  @override
  String convert(String input) {
    var returnValue = '';
    for (var i = 0; i < input.length; ++i) {
      if (input[i].isAlpha) {
        var magicNumber =
            input[i].isLowerCaseAlpha ? 'a'.codeUnitAt(0) : 'A'.codeUnitAt(0);
        var currentIndex = input.codeUnitAt(i) - magicNumber;
        returnValue +=
            String.fromCharCode((currentIndex - _otp[i]) % 26 + magicNumber);
      } else {
        returnValue += input[i];
      }
    }
    return returnValue;
  }

  @override
  Sink<String> startChunkedConversion(Sink<String> sink) {
    return StringEventConverterSink(sink, this);
  }
}

//ignore: public_member_api_docs
class StringEventConverterSink extends StringConversionSinkMixin {
  /// The sink used internally
  Sink<String> sink;

  /// The converter used internally
  Converter<String, String> converter;

  /// Creates a new sink
  StringEventConverterSink(this.sink, this.converter);

  @override
  void addSlice(String str, int start, int end, bool isLast) {
    sink.add(converter.convert(str));
  }

  @override
  void close() {
    sink.close();
  }
}
