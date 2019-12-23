## `otp help`
```
One-time pad implementation.

Usage: otp <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  decrypt    Decrypt an encrypted message using an existing one-time pad.
  encrypt    Encrypt a provided message with an existing one-time pad or generate a new one.
  generate   Generates new one-time pad of fixed length
  help       Display help information for otp.

Run "otp help <command>" for more information about a command.
```

## `otp help decrypt`
```
Decrypt messages using otp.

Usage: otp decrypt [options] [file | -]
-h, --help               Print this usage information.
-o, --output=<FILE>      File to output the message to, if not specified, the result will be printed to stdout
-O, --otp-file=<FILE>    One-time pad file to use, this option is required

Run "otp help" to see global options.
```

## `otp help encrypt`
```
Encrypt messages using otp.

Usage: otp encrypt [options] [file | -]
-h, --help                 Print this usage information.
-o, --output=<FILE>        File to output the message to, if not specified, the result will be printed to stdout
-O, --otp-file=<FILE>      One-time pad file to use, this option is required
-g, --[no-]generate-otp    If specified, will overrite the file specified in --opt-file with a newly-generated one, disabled by default

Run "otp help" to see global options.
```
## `otp help generate`
```
Generate one-time pads.

Usage: otp generate -l|--length=<INT> [out_file | -]
-h, --help            Print this usage information.
-l, --length=<INT>    The length in bytes of the generated otp, this option in required.

Run "otp help" to see global options.
```
