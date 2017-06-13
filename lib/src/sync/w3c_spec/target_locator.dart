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

import 'alert.dart';

import '../alert.dart';
import '../common.dart';
import '../target_locator.dart';
import '../web_driver.dart';
import '../window.dart';

class W3cTargetLocator implements TargetLocator {
  final WebDriver _driver;
  final Resolver _resolver;

  W3cTargetLocator(this._driver) : _resolver = new Resolver(_driver, '');

  @override
  void frame([frame]) => _resolver.post('frame', {'id': frame});

  @Deprecated('Use "Window.setAsActive()". '
      'Selecting by name is not supported by the current W3C spec.')
  @override
  //TODO(staats): create an exception for this.
  void window(dynamic window) => throw 'Unsupported by W3C spec';

  @override
  Alert get alert => new W3cAlert(_driver);

  @override
  String toString() => '$_driver.switchTo';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) =>
      other is W3cTargetLocator && other._driver == _driver;
}
