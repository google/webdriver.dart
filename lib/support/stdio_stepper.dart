library webdriver.support.stdio_stepper;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:webdriver/src/stepper.dart';

/// Provides a command line interface for stepping through or skipping
/// WebDriver commands.
class StdioStepper implements Stepper {
  StdioStepper() {
    stdin.lineMode = true;
  }

  Future<bool> step(String method, String command, params) async {
    print('$method $command(${JSON.encode(params)}):');
    while (true) {
      var command = stdin.readLineSync(retainNewlines: false).trim();
      switch (command) {
        case 'continue':
        case 'c':
          return true;
        case 'skip':
        case 's':
          return false;
        case 'break':
        case 'b':
          throw new Exception('process ended by user.');
        case 'help':
        case 'h':
          _printUsage();
          break;
        default:
          print('invalid command: `$command` enter `h` or `help` for help.');
      }
    }
  }

  _printUsage() {
    print('`c` or `continue`: to execute command');
    print('`s` or `skip`: skip command');
    print('`b` or `break`: stop execution');
    print('`h` or `help`: display this message');
  }
}
