// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of webdriver;

class Mouse extends _WebDriverBase {
  static const int LEFT = 0;
  static const int MIDDLE = 1;
  static const int RIGHT = 2;

  Mouse._(driver) : super(driver, '');

  /// Click any mouse button (at the coordinates set by the last moveTo).
  Future click([int button]) async {
    var json = {};
    if (button is num) {
      json['button'] = button.clamp(0, 2).floor();
    }
    await _post('click', json);
  }

  /// Click and hold any mouse button (at the coordinates set by the last
  /// moveTo command).
  Future down([int button]) async {
    var json = {};
    if (button is num) {
      json['button'] = button.clamp(0, 2).floor();
    }
    await _post('buttondown', json);
  }

  /// Releases the mouse button previously held (where the mouse is currently at).
  Future up([int button]) async {
    var json = {};
    if (button is num) {
      json['button'] = button.clamp(0, 2).floor();
    }
    await _post('buttonup', json);
  }

  /// Double-clicks at the current mouse coordinates (set by moveTo).
  Future doubleClick() async {
    await _post('doubleclick');
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
  Future moveTo({WebElement element, int xOffset, int yOffset}) async {
    var json = {};
    if (element is WebElement) {
      json['element'] = element.id;
    }
    if (xOffset is num && yOffset is num) {
      json['xoffset'] = xOffset.floor();
      json['yoffset'] = yOffset.floor();
    }
    await _post('moveto', json);
  }

  @override
  String toString() => '$driver.mouse';

  @override
  int get hashCode => driver.hashCode;

  @override
  bool operator ==(other) => other is Mouse && other.driver == driver;
}
