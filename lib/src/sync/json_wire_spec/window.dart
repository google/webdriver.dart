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

import 'dart:math' show Point, Rectangle;

import '../common.dart';
import '../web_driver.dart';
import '../window.dart';

class JsonWireWindows implements Windows {
  final WebDriver _driver;
  final Resolver _resolver;

  JsonWireWindows(this._driver) : _resolver = new Resolver(_driver, '');

  @override
  Window get activeWindow =>
      new JsonWireWindow(_driver, _resolver.get('window_handle') as String);

  @override
  List<Window> get allWindows =>
      (_resolver.get('window_handles') as List<String>)
          .map((handle) => new JsonWireWindow(_driver, handle))
          .toList();
}

class JsonWireWindow implements Window {
  final WebDriver _driver;
  final String _handle;
  final Resolver _handleResolver;
  final Resolver _session;

  JsonWireWindow(this._driver, this._handle)
      : _handleResolver = new Resolver(_driver, 'window/$_handle'),
        _session = new Resolver(_driver, '');

  @override
  Rectangle<int> get size {
    final size = _handleResolver.get('size');
    return new Rectangle<int>(
        0, 0, size['width'].toInt(), size['height'].toInt());
  }

  @override
  Point<int> get location {
    final point = _handleResolver.get('position');
    return new Point<int>(point['x'].toInt(), point['y'].toInt());
  }

  @override
  Rectangle<int> get rect {
    final curLocation = this.location;
    final curSize = this.size;
    return new Rectangle<int>(
        curLocation.x, curLocation.y, curSize.width, curSize.height);
  }

  @override
  void set rect(Rectangle<int> location) {
    setSize(location);
    setLocation(new Point(location.left, location.top));
  }

  @override
  void maximize() {
    _handleResolver.post('maximize');
  }

  @override
  void setSize(Rectangle<int> size) {
    _handleResolver.post(
        'size', {'width': size.width.toInt(), 'height': size.height.toInt()});
  }

  @override
  void setLocation(Point<int> point) {
    _handleResolver
        .post('position', {'x': point.x.toInt(), 'y': point.y.toInt()});
  }

  @override
  void setAsActive() => _session.post('window', {'name': _handle});

  @override
  int get hashCode => _handle.hashCode * 3 + _driver.hashCode;

  @override
  bool operator ==(other) =>
      other is JsonWireWindow &&
      other._driver == this._driver &&
      other._handle == this._handle;

  @override
  String toString() => '$_driver.windows[$_handle]';
}
