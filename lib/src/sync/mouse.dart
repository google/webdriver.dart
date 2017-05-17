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
import 'web_element.dart';

class MouseButton {
  /// The primary button is usually the left button or the only button on
  /// single-button devices, used to activate a user interface control or select
  /// text.
  static const MouseButton primary = const MouseButton(0);

  /// The auxiliary button is usually the middle button, often combined with a
  /// mouse wheel.
  static const MouseButton auxiliary = const MouseButton(1);

  /// The secondary button is usually the right button, often used to display a
  /// context menu.
  static const MouseButton secondary = const MouseButton(2);

  final int value;

  /// [value] for a mouse button is defined in
  /// https://w3c.github.io/uievents/#widl-MouseEvent-button
  const MouseButton(this.value);
}

class Mouse {
  final WebDriver _driver;
  final WebDriverBase _resolver;

  Mouse(this._driver) : _resolver = new WebDriverBase(_driver, '');

  /// Click any mouse button (at the coordinates set by the last moveTo).
  void click([MouseButton button]) {
    var json = {};
    if (button is MouseButton) {
      json['button'] = button.value;
    }
    _resolver.post('click', json);
  }

  /// Click and hold any mouse button (at the coordinates set by the last
  /// moveTo command).
  void down([MouseButton button]) {
    var json = {};
    if (button is MouseButton) {
      json['button'] = button.value;
    }
    _resolver.post('buttondown', json);
  }

  /// Releases the mouse button previously held (where the mouse is currently at).
  void up([MouseButton button]) {
    var json = {};
    if (button is MouseButton) {
      json['button'] = button.value;
    }
    _resolver.post('buttonup', json);
  }

  /// Double-clicks at the current mouse coordinates (set by moveTo).
  void doubleClick() {
    _resolver.post('doubleclick');
  }

  /// Move the mouse.
  ///
  /// If [element] is specified and [xOffset] and [yOffset] are not, will move
  /// the mouse to the center of the [element].
  ///
  /// If [xOffset] and [yOffset] are specified, will move the mouse that distance
  /// from its current location.
  ///
  /// If all three are specified, will move the mouse to the offset relative to
  /// the top-left corner of the [element].
  /// All other combinations of parameters are illegal.
  void moveTo({WebElement element, int xOffset, int yOffset}) {
    var json = {};
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
  bool operator ==(other) => other is Mouse && other._driver == _driver;
}
