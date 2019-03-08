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

import 'package:webdriver/src/async/web_element.dart';
import 'package:webdriver/src/common/mouse.dart';
import 'package:webdriver/src/common/request_client.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';

class Mouse {
  final AsyncRequestClient _client;
  final WebDriverHandler _handler;

  Mouse(this._client, this._handler);

  /// Click any mouse button (at the coordinates set by the last moveTo).
  Future<void> click([MouseButton button = MouseButton.primary]) =>
      _client.send(_handler.mouse.buildClickRequest(button),
          _handler.mouse.parseClickResponse);

  /// Click and hold any mouse button (at the coordinates set by the last
  /// moveTo command).
  Future<void> down([MouseButton button = MouseButton.primary]) => _client.send(
      _handler.mouse.buildDownRequest(button),
      _handler.mouse.parseDownResponse);

  /// Releases the mouse button previously held (where the mouse is currently at).
  Future<void> up([MouseButton button = MouseButton.primary]) => _client.send(
      _handler.mouse.buildUpRequest(button), _handler.mouse.parseUpResponse);

  /// Double-clicks at the current mouse coordinates (set by moveTo).
  Future<void> doubleClick() => _client.send(
      _handler.mouse.buildDoubleClickRequest(),
      _handler.mouse.parseDoubleClickResponse);

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
  ///
  /// All other combinations of parameters are illegal.
  ///
  /// Special notes for W3C, if the destination is out of the current viewport,
  /// an 'MoveTargetOutOfBounds' exception will be thrown.
  Future<void> moveTo(
          {WebElement element,
          int xOffset,
          int yOffset,
          bool absolute = false}) =>
      _client.send(
          _handler.mouse.buildMoveToRequest(
              elementId: element?.id,
              xOffset: xOffset,
              yOffset: yOffset,
              absolute: absolute),
          _handler.mouse.parseMoveToResponse);

  @override
  String toString() => '$_handler.mouse($_client)';

  @override
  int get hashCode => _client.hashCode;

  @override
  bool operator ==(other) =>
      other is Mouse && _handler == other._handler && _client == other._client;
}
