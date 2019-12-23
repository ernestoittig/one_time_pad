import 'package:test/test.dart';

import 'package:one_time_pad/one_time_pad.dart';

void main() {
  test("generateOneTimePad() generates an otp of given size", () {
    var otp = generateOneTimePad();
    expect(otp, hasLength(100));
    otp = generateOneTimePad(5000);
    expect(otp, hasLength(5000));
  });
}
