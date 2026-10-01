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

import 'dart:async';

import '../common/geometry.dart';
import '../common/request_client.dart';
import '../common/webdriver_handler.dart';

class Window {
  final AsyncRequestClient _client;
  final WebDriverHandler _handler;
  final String id;

  Window(this._client, this._handler, this.id);

  /// Sets the window as active.
  Future<void> setAsActive() => _client.send(
      _handler.window.buildSetActiveRequest(id),
      _handler.window.parseSetActiveResponse);

  /// The position of the top-left corner of the window on the screen.
  Future<Position> get location => _client.send(
      _handler.window.buildLocationRequest(),
      _handler.window.parseLocationResponse);

  /// The outer size of the window,
  /// including browser interface elements such as toolbars and borders.
  Future<Size> get size => _client.send(
      _handler.window.buildSizeRequest(), _handler.window.parseSizeResponse);

  /// The viewport size of the currently selected browsing context,
  /// as reported by `window.innerWidth` and `window.innerHeight`.
  ///
  /// If a frame is selected, this is the size of that frame's viewport.
  Future<Size> get innerSize => _client.send(
      _handler.window.buildInnerSizeRequest(),
      _handler.window.parseInnerSizeResponse);

  /// The position and outer size of the window.
  Future<Rect> get rect async {
    try {
      return await _client.send(_handler.window.buildRectRequest(),
          _handler.window.parseRectResponse);
    } on UnsupportedError {
      // JsonWire cannot implement this API in one call.
      // Delegate to other methods.
      final location = await this.location;
      final size = await this.size;
      return Rect.from(topLeft: location, size: size);
    }
  }

  /// Requests that the window be moved so its top-left corner is at [position].
  ///
  /// The actual resulting position might differ due to
  /// browser or window manager constraints.
  Future<void> setLocation(Position position) => _client.send(
      _handler.window.buildSetLocationRequest(position),
      _handler.window.parseSetLocationResponse);

  /// Requests that the window be resized so its outer size is [size].
  ///
  /// The actual resulting size might differ due to
  /// browser or window manager constraints.
  Future<void> setSize(Size size) => _client.send(
      _handler.window.buildSetSizeRequest(size),
      _handler.window.parseSetSizeResponse);

  /// Requests that the window be moved and resized to
  /// the position and outer size specified by [rect].
  ///
  /// The actual resulting position and size might differ due to
  /// browser or window manager constraints.
  Future<void> setRect(Rect rect) async {
    try {
      await _client.send(_handler.window.buildSetRectRequest(rect),
          _handler.window.parseSetRectResponse);
      return;
    } on UnsupportedError {
      // JsonWire cannot implement this API in one call.
      // Delegate to other methods.
      await setLocation(rect.topLeft);
      await setSize(rect.size);
    }
  }

  /// Maximizes the window.
  Future<void> maximize() => _client.send(
      _handler.window.buildMaximizeRequest(),
      _handler.window.parseMaximizeResponse);

  /// Minimizes the window.
  ///
  /// Unsupported in JsonWire WebDriver.
  Future<void> minimize() => _client.send(
      _handler.window.buildMinimizeRequest(),
      _handler.window.parseMinimizeResponse);

  /// Closes the window.
  Future close() => _client.send(
      _handler.window.buildCloseRequest(), _handler.window.parseCloseResponse);

  @override
  int get hashCode => id.hashCode + _client.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Window &&
      other._client == _client &&
      other._handler == _handler &&
      other.id == id;

  @override
  String toString() => '$_handler.windows($_client)[$id]';
}
