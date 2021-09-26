import 'dart:math';

import 'dart:typed_data';

/// Generate a new one-time pad of [length]
Uint8List generateOneTimePad([int length = 100]) {
  var random = Random.secure();
  var returnValue = Uint8List(length);
  for (var i = 0; i < length; ++i) {
    returnValue[i] = random.nextInt(26);
  }
  return returnValue;
}
