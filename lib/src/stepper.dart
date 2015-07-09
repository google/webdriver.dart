library webdriver.stepper;

import 'dart:async';

class Stepper {
  const Stepper();

  /// returns true if command should be executed, false if should not be executed.
  Future<bool> step(String method, String command, params) =>
      new Future.value(true);
}
