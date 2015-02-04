// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of webdriver;

class Keyboard extends _WebDriverBase {
  Keyboard._(driver) : super(driver, '');

  /**
   * Send [keysToSend] to the active element.
   */
  Future sendKeys(String keysToSend) async {
    await _post('keys', {'value': [keysToSend]});
  }

  @override
  String toString() => '$driver.keyboard';

  @override
  int get hashCode => driver.hashCode;

  @override
  bool operator ==(other) => other is Keyboard && other.driver == driver;
}
