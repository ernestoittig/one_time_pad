/// Utility methods on [String]
extension OtpString on String {
  /// Returns true if all characters in this are lower-case alphabet characters (a-z)
  bool get isLowerCaseAlpha {
    return RegExp(r'^[a-z]*$').hasMatch(this);
  }

  /// Returns true if all characters in this are upper-case alphabet characters (A-Z)
  bool get isUpperCaseAlpha {
    return RegExp(r'^[A-Z]*$').hasMatch(this);
  }

  /// Returns true if all characters in this are alphabet characters (A-Za-z)
  bool get isAlpha => RegExp(r'^[A-Za-z]*$').hasMatch(this);
}
