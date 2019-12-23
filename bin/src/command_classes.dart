import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/command_runner.dart';

import 'package:one_time_pad/one_time_pad.dart';

class EncryptCommand extends Command {
  final String name = "encrypt",
      description = "Encrypt messages using otp.",
      summary =
          "Encrypt a provided message with an existing one-time pad or generate a new one.";

  String get invocation =>
      '${runner.executableName} $name [options] [file | -]';

  EncryptCommand() {
    argParser
      ..addOption('output',
          abbr: 'o',
          help:
              'File to output the message to, if not specified, the result will be printed to stdout',
          valueHelp: 'FILE')
      ..addOption('otp-file',
          abbr: 'O',
          help: 'One-time pad file to use, this option is required',
          valueHelp: 'FILE')
      ..addFlag('generate-otp',
          abbr: 'g',
          help:
              'If specified, will overrite the file specified in --opt-file with a newly-generated one, disabled by default');
  }

  void run() async {
    if (argResults['otp-file'] == null) {
      usageException('One-time pad file not specified.');
    }
    var otpFile = File(argResults['otp-file']);

    Uint8List input;
    if (argResults.rest.isEmpty || argResults.rest[0] == '-') {
      var inputList = await stdin.reduce((a, b) => a + b);
      input = Uint8List.fromList(inputList);
    } else {
      input = File(argResults.rest[0]).readAsBytesSync();
    }
    Uint8List otp;
    if (argResults['generate-otp']) {
      otp = generateOneTimePad(input.length);
      otpFile.writeAsBytesSync(otp);
    } else {
      otp = otpFile.readAsBytesSync();
    }
    var inputString = utf8.decode(input, allowMalformed: true);
    String output;
    try {
      output = OtpEncoder(otp).convert(inputString);
    } on RangeError {
      usageException('OTP length less than message length.');
    }
    if (argResults['output'] == null) {
      stdout.write(output);
    } else {
      File(argResults['output']).writeAsStringSync(output);
    }
  }
}

class DecryptCommand extends Command {
  final String name = "decrypt",
      description = "Decrypt messages using otp.",
      summary = 'Decrypt an encrypted message using an existing one-time pad.';

  String get invocation =>
      '${runner.executableName} $name [options] [file | -]';

  DecryptCommand() {
    argParser
      ..addOption('output',
          abbr: 'o',
          help:
              'File to output the message to, if not specified, the result will be printed to stdout',
          valueHelp: 'FILE')
      ..addOption('otp-file',
          abbr: 'O',
          help: 'One-time pad file to use, this option is required',
          valueHelp: 'FILE');
  }

  void run() async {
    if (argResults['otp-file'] == null) {
      usageException('One-time pad file not specified.');
    }
    var otpFile = File(argResults['otp-file']);

    Uint8List input;
    if (argResults.rest.isEmpty || argResults.rest[0] == '-') {
      var inputList = await stdin.reduce((a, b) => a + b);
      input = Uint8List.fromList(inputList);
    } else {
      input = File(argResults.rest[0]).readAsBytesSync();
    }
    Uint8List otp;

    otp = otpFile.readAsBytesSync();
    var inputString = utf8.decode(input, allowMalformed: true);
    String output;
    try {
      output = OtpDecoder(otp).convert(inputString);
    } on RangeError {
      usageException('OTP length less than message length.');
    }
    if (argResults['output'] == null) {
      stdout.write(output);
    } else {
      File(argResults['output']).writeAsStringSync(output);
    }
  }
}

class GenerateCommand extends Command {
  final String name = 'generate',
      description = 'Generate one-time pads.',
      summary = 'Generates new one-time pad of fixed length';

  String get invocation =>
      '${runner.executableName} $name -l|--length=<INT> [out_file | -]';

  GenerateCommand() {
    argParser.addOption('length',
        abbr: 'l',
        help:
            'The length in bytes of the generated otp, this option in required.',
        valueHelp: 'INT');
  }

  void run() {
    if (argResults['length'] == null) usageException('Length not specified.');
    var length = int.tryParse(argResults['length']);
    if (length == null) usageException('Length specified is an invalid integer.');
    var output = generateOneTimePad(length);
    if (argResults.rest.isEmpty || argResults.rest[0] == '-') {
      for (var x in output) {
        stdout.writeCharCode(x);
      }
    } else {
      File(argResults.rest[0]).writeAsBytesSync(output);
    }
  }
}
