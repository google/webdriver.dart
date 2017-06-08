// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'common.dart';
import 'web_driver.dart';

/// A JavaScript alert(), confirm(), or prompt() dialog
class Alert {
  /// The text of the JavaScript alert(), confirm(), or prompt() dialog.
  final String text;
  final WebDriver _driver;
  final Resolver _resolver;

  Alert(this.text, this._driver) : _resolver = new Resolver(_driver, '');

  /// Accepts the currently displayed alert (may not be the alert for which this
  /// object was created).
  ///
  ///  Throws [NoSuchAlertException] if there isn't currently an alert.
  void accept() {
    _resolver.post('accept_alert');
  }

  /// Dismisses the currently displayed alert (may not be the alert for which
  /// this object was created).
  ///
  ///  Throws [NoSuchAlertException] if there isn't currently an alert.
  void dismiss() {
    _resolver.post('dismiss_alert');
  }

  /// Sends keys to the currently displayed alert (may not be the alert for
  /// which this object was created).
  ///
  /// Throws [NoSuchAlertException] if there isn't currently an alert
  void sendKeys(String keysToSend) {
    _resolver.post('alert_text', {'text': keysToSend});
  }

  @override
  String toString() => '$_driver.switchTo.alert[$text]';
}
