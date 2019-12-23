import 'dart:math';

import 'dart:typed_data';

/// Generate a new one-time pad of [length]
Uint8List generateOneTimePad([int length = 100]) {
  var random = Random.secure();
  var retval = <int>[];
  for (var i = 0; i < length; ++i) {
    retval.add(random.nextInt(26));
  }
  return Uint8List.fromList(retval);
}
