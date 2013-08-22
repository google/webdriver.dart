library webdriver_test;

import 'dart:io' as io;
import 'package:path/path.dart' as pathos;
import 'package:webdriver/webdriver.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/compact_vm_config.dart';

part 'src/alert_test.dart';
part 'src/keyboard_test.dart';
part 'src/mouse_test.dart';
part 'src/navigation_test.dart';
part 'src/options_test.dart';
part 'src/target_locator_test.dart';
part 'src/webdriver_test.dart';
part 'src/webelement_test.dart';
part 'src/window_test.dart';

final Matcher isWebDriverError = new isInstanceOf<WebDriverError>();
final Matcher isWebElement = new isInstanceOf<WebElement>();
final Matcher isSize = new isInstanceOf<Size>();
final Matcher isPoint = new isInstanceOf<Point>();

/**
 * These tests are not expected to be run as part of normal automated testing,
 * as they are slow and they have external dependencies.
 */
void main() {
  useCompactVMConfiguration();

  new AlertTest().main();
  new KeyboardTest().main();
  new MouseTest().main();
  new NavigationTest().main();
  new OptionsTest().main();
  new TargetLocatorTest().main();
  new WebDriverTest().main();
  new WebElementTest().main();
  new WindowTest().main();
}

final _testPagePath = _getTestPagePath();

String _getTestPagePath() {
  var scriptPath = (new io.Options()).script;
  var scriptDir = pathos.dirname(scriptPath);
  var testPagePath = pathos.join(scriptDir, 'test_page.html');
  testPagePath = pathos.absolute(testPagePath);
  return pathos.toUri(testPagePath).toString();
}
