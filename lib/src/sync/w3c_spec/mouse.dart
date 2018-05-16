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

class W3cMouse extends Mouse {
  final WebDriver _driver;
  final Resolver _resolver;

  W3cMouse(this._driver) : _resolver = new Resolver(_driver, '');

  @override
  void click([MouseButton button = MouseButton.primary]) {
    _resolver.post('actions', {
      'actions': [
        {
          'type': 'pointer',
          'id': 'mouses',
          'actions': [
            {'type': 'pointerDown', 'button': button.value},
            {'type': 'pointerUp', 'button': button.value}
          ]
        }
      ]
    });
  }

  @override
  void down([MouseButton button = MouseButton.primary]) {
    _resolver.post('actions', {
      'actions': [
        {
          'type': 'pointer',
          'id': 'mouses',
          'actions': [
            {'type': 'pointerDown', 'button': button.value}
          ]
        }
      ]
    });
  }

  @override
  void up([MouseButton button = MouseButton.primary]) {
    _resolver.post('actions', {
      'actions': [
        {
          'type': 'pointer',
          'id': 'mouses',
          'actions': [
            {'type': 'pointerUp', 'button': button.value}
          ]
        }
      ]
    });
  }

  @override
  void doubleClick() {
    _resolver.post('actions', {
      'actions': [
        {
          'type': 'pointer',
          'id': 'mouses',
          'actions': [
            {'type': 'pointerDown', 'button': MouseButton.primary.value},
            {'type': 'pointerUp', 'button': MouseButton.primary.value},
            {'type': 'pointerDown', 'button': MouseButton.primary.value},
            {'type': 'pointerUp', 'button': MouseButton.primary.value}
          ]
        }
      ]
    });
  }

  @override
  void moveTo({WebElement element, int xOffset, int yOffset}) {
    _resolver.post('actions', {
      'actions': [
        {
          'type': 'pointer',
          'id': 'mouses',
          'actions': [
            {
              'type': 'pointerMove',
              'origin': element is WebElement
                  ? {w3cElementStr: element.id}
                  : 'pointer',
              'x': xOffset ?? 0,
              'y': yOffset ?? 0
            }
          ]
        }
      ]
    });
  }

  @override
  String toString() => '$_driver.mouse';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) => other is W3cMouse && other._driver == _driver;
}
