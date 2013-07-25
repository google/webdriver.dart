library webdriver_test;
import 'dart:async' show getAttachedStackTrace;
import 'package:webdriver/webdriver.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

part 'src/webdriver_test.dart';

/**
 * These tests are not expected to be run as part of normal automated testing,
 * as they are slow and they have external dependencies.
 */
main() {
  useVMConfiguration();

  new WebDriverTest().main();
}

