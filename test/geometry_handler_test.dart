// Copyright 2026 Google Inc. All Rights Reserved.
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

import 'dart:convert';

import 'package:test/test.dart';
import 'package:webdriver/async_core.dart';
import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/handler/json_wire_handler.dart';
import 'package:webdriver/src/handler/w3c_handler.dart';

void main() {
  // Both protocols accept this successful response envelope.
  WebDriverResponse response(Map<String, num> value) =>
      WebDriverResponse(200, 'OK', jsonEncode({'status': 0, 'value': value}));

  const geometries = <(String, Map<String, num>)>[
    ('integer', {'x': -12, 'y': 34, 'width': 56, 'height': 78}),
    ('fractional', {'x': -12.9, 'y': 34.9, 'width': 56.9, 'height': 78.9}),
  ];

  for (final (handler, :locationUri, :sizeUri) in [
    (
      JsonWireWebDriverHandler(),
      locationUri: 'window/current/position',
      sizeUri: 'window/current/size',
    ),
    (W3cWebDriverHandler(), locationUri: 'window/rect', sizeUri: 'window/rect'),
  ]) {
    group(handler.runtimeType.toString(), () {
      for (final (label, value) in geometries) {
        test('parses $label geometry', () {
          final data = response(value);
          const position = Position(x: -12, y: 34);
          const size = Size(width: 56, height: 78);
          expect(handler.element.parseLocationResponse(data), position);
          expect(handler.element.parseSizeResponse(data), size);
          expect(handler.window.parseLocationResponse(data), position);
          expect(handler.window.parseSizeResponse(data), size);
          expect(handler.window.parseInnerSizeResponse(data), size);
        });
      }

      test('preserves empty sizes', () {
        final data = response({'x': -12, 'y': 34, 'width': 0, 'height': 0});
        const size = Size(width: 0, height: 0);
        expect(handler.element.parseSizeResponse(data), size);
        expect(handler.window.parseSizeResponse(data), size);
        expect(handler.window.parseInnerSizeResponse(data), size);
      });

      test('serializes position and size without extra fields', () {
        final location = handler.window
            .buildSetLocationRequest(const Position(x: -12, y: 34));
        final size = handler.window
            .buildSetSizeRequest(const Size(width: 56, height: 78));
        expect(location.method, HttpMethod.httpPost);
        expect(size.method, HttpMethod.httpPost);
        expect(location.uri, locationUri);
        expect(size.uri, sizeUri);
        expect(jsonDecode(location.body!), {'x': -12, 'y': 34});
        expect(jsonDecode(size.body!), {'width': 56, 'height': 78});
      });
    });
  }

  group('W3C window rect', () {
    final window = W3cWebDriverHandler().window;

    for (final (label, value) in geometries) {
      test('parses $label geometry', () {
        expect(window.parseRectResponse(response(value)),
            const Rect(left: -12, top: 34, width: 56, height: 78));
      });
    }

    test('serializes all rectangle fields', () {
      final request = window.buildSetRectRequest(
          const Rect(left: -12, top: 34, width: 56, height: 78));
      expect(request.method, HttpMethod.httpPost);
      expect(request.uri, 'window/rect');
      expect(jsonDecode(request.body!),
          {'x': -12, 'y': 34, 'width': 56, 'height': 78});
    });
  });

  test('JsonWire does not support window rect', () {
    final window = JsonWireWebDriverHandler().window;
    expect(window.buildRectRequest, throwsUnsupportedError);
    expect(
        () => window.buildSetRectRequest(
            const Rect(left: 0, top: 0, width: 0, height: 0)),
        throwsUnsupportedError);
  });
}
