// Copyright 2017 Google Inc. All Rights Reserved.
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

import '../alert.dart';
import '../common.dart';
import '../web_driver.dart';

/// A JavaScript alert(), confirm(), or prompt() dialog for the JSON wire spec.
class JsonWireAlert implements Alert {
  final String _text;
  final WebDriver _driver;
  final Resolver _resolver;

  JsonWireAlert(this._text, this._driver)
      : _resolver = new Resolver(_driver, '');

  String get text => _text;

  @override
  void accept() {
    _resolver.post('accept_alert');
  }

  @override
  void dismiss() {
    _resolver.post('dismiss_alert');
  }

  @override
  void sendKeys(String keysToSend) {
    _resolver.post('alert_text', {'text': keysToSend});
  }

  @override
  String toString() => '$_driver.switchTo.alert[$text]';
}
