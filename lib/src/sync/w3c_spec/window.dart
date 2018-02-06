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

import 'dart:math' show Point, Rectangle;

import '../common.dart';
import '../web_driver.dart';
import '../window.dart';

class W3cWindows implements Windows {
  final WebDriver _driver;
  final Resolver _resolver;

  W3cWindows(this._driver) : _resolver = new Resolver(_driver, '');

  @override
  Window get activeWindow =>
      new W3cWindow(_driver, _resolver.get('window') as String);

  @override
  List<Window> get allWindows =>
      (_resolver.get('window/handles') as List<String>)
          .map((handle) => new W3cWindow(_driver, handle))
          .toList();
}

class W3cWindow implements Window {
  final WebDriver _driver;
  final String _handle;
  final Resolver _windowResolver;
  final Resolver _session;

  W3cWindow(this._driver, this._handle)
      : _windowResolver = new Resolver(_driver, 'window'),
        _session = new Resolver(_driver, '');

  // TODO(staats): better exceptions.
  @override
  Rectangle<int> get size =>
      throw 'Unsupported by W3C spec, use "rect" instead.';

  @override
  Point<int> get location =>
      throw 'Unsupported by W3C spec, use "rect" instead.';

  @override
  void setSize(Rectangle<int> size) =>
      throw 'Unsupported by W3C spec, use "rect" instead.';

  @override
  void setLocation(Point<int> point) =>
      throw 'Unsupported by W3C spec, use "rect" instead.';

  @override
  Rectangle<int> get rect {
    final rect = _windowResolver.get('rect');
    return new Rectangle(rect['x'].toInt(), rect['y'].toInt(),
        rect['width'].toInt(), rect['height'].toInt());
  }

  @override
  set rect(Rectangle<int> location) => _windowResolver.post('rect', {
        'x': location.left,
        'y': location.top,
        'width': location.width,
        'height': location.height
      });

  @override
  void maximize() => _windowResolver.post('maximize', {});

  @override
  void setAsActive() => _session.post('window', {'handle': _handle});

  @override
  int get hashCode => _handle.hashCode * 3 + _driver.hashCode;

  @override
  bool operator ==(other) =>
      other is W3cWindow &&
      other._driver == this._driver &&
      other._handle == this._handle;

  @override
  String toString() => '$_driver.windows[$_handle]';
}
