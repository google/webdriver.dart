library webdriver_test;

import 'package:unittest/compact_vm_config.dart';

import 'src/alert_test.dart' as alert;
import 'src/keyboard_test.dart' as keyboard;
import 'src/mouse_test.dart' as mouse;
import 'src/navigation_test.dart' as navigation;
import 'src/options_test.dart' as options;
import 'src/target_locator_test.dart' as target_locator;
import 'src/web_driver_test.dart' as web_driver;
import 'src/web_element_test.dart' as web_element;
import 'src/window_test.dart' as window;

/**
 * These tests are not expected to be run as part of normal automated testing,
 * as they are slow and they have external dependencies.
 */
void main() {
  useCompactVMConfiguration();

  alert.main();
  keyboard.main();
  mouse.main();
  navigation.main();
  options.main();
  target_locator.main();
  web_driver.main();
  web_element.main();
  window.main();
}
