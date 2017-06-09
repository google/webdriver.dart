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

import '../common.dart';
import '../timeouts.dart';
import '../web_driver.dart';

class JsonWireTimeouts extends Timeouts {
  final WebDriver _driver;
  final Resolver _resolver;

  JsonWireTimeouts(this._driver)
      : _resolver = new Resolver(_driver, 'timeouts');

  void _set(String type, Duration duration) {
    _resolver.post('', {'type': type, 'ms': duration.inMilliseconds});
  }

  @override
  void setScriptTimeout(Duration duration) => _set('script', duration);

  @override
  void setImplicitTimeout(Duration duration) => _set('implicit', duration);

  @override
  void setPageLoadTimeout(Duration duration) => _set('page load', duration);

  @override
  String toString() => '$_driver.timeouts';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) =>
      other is JsonWireTimeouts && other._driver == _driver;
}
