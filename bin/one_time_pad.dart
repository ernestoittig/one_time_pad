import 'dart:io';

import 'package:args/command_runner.dart';

import 'src/command_classes.dart';

void main(List<String> args) async {
  var runner = CommandRunner("otp", "One-time pad implementation.")
    ..addCommand(EncryptCommand())
    ..addCommand(DecryptCommand())
    ..addCommand(GenerateCommand());
  try {
    await runner.run(args);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  } on FileSystemException catch (e) {
    // Remove the FileSystemException at the begining so it looks nicer :)
    stderr.writeln('$e'.replaceFirst('FileSystemException: ', ''));
    exit(66);
  }
}
