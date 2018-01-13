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

import '../common.dart';
import '../navigation.dart';
import '../web_driver.dart';

/// Browser navigation actions.
class JsonWireNavigation implements Navigation {
  final WebDriver _driver;
  final Resolver _resolver;

  JsonWireNavigation(this._driver) : _resolver = new Resolver(_driver, '');

  ///  Navigate forwards in the browser history, if possible.
  @override
  void forward() {
    _resolver.post('forward');
  }

  /// Navigate backwards in the browser history, if possible.
  @override
  void back() {
    _resolver.post('back');
  }

  /// Refresh the current page.
  @override
  void refresh() {
    _resolver.post('refresh');
  }

  @override
  String toString() => '$_driver.navigate';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) =>
      other is JsonWireNavigation && other._driver == _driver;
}
