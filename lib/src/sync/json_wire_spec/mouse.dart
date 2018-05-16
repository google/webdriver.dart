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
import '../web_driver.dart';
import '../web_element.dart';
import '../mouse.dart';

class JsonWireMouse extends Mouse {
  final WebDriver _driver;
  final Resolver _resolver;

  JsonWireMouse(this._driver) : _resolver = new Resolver(_driver, '');

  @override
  void click([MouseButton button]) {
    final json = {};
    if (button is MouseButton) {
      json['button'] = button.value;
    }
    _resolver.post('click', json);
  }

  @override
  void down([MouseButton button]) {
    final json = {};
    if (button is MouseButton) {
      json['button'] = button.value;
    }
    _resolver.post('buttondown', json);
  }

  @override
  void up([MouseButton button]) {
    final json = {};
    if (button is MouseButton) {
      json['button'] = button.value;
    }
    _resolver.post('buttonup', json);
  }

  @override
  void doubleClick() {
    _resolver.post('doubleclick');
  }

  @override
  void moveTo({WebElement element, int xOffset, int yOffset}) {
    final json = {};
    if (element is WebElement) {
      json['element'] = element.id;
    }
    if (xOffset is num && yOffset is num) {
      json['xoffset'] = xOffset.floor();
      json['yoffset'] = yOffset.floor();
    }
    _resolver.post('moveto', json);
  }

  @override
  String toString() => '$_driver.mouse';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) => other is JsonWireMouse && other._driver == _driver;
}
