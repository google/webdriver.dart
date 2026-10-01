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

import 'package:test/test.dart';
import 'package:webdriver/async_core.dart';
import 'package:webdriver/sync_core.dart' as sync;

void main() {
  test('geometry types are shared by the async and sync APIs', () {
    expect(const Position(x: -2, y: 3), const sync.Position(x: -2, y: 3));
    expect(
        const Size(width: 4, height: 5), const sync.Size(width: 4, height: 5));
    expect(const Rect(left: -2, top: 3, width: 4, height: 5),
        const sync.Rect(left: -2, top: 3, width: 4, height: 5));
  });

  test('positions have value equality and work as map keys', () {
    // Exercise value equality between distinct, non-canonical instances.
    // ignore: prefer_const_constructors
    final position = Position(x: -2, y: 3);
    expect(position, const Position(x: -2, y: 3));
    for (final other in const [Position(x: -1, y: 3), Position(x: -2, y: 4)]) {
      expect(position, isNot(other));
    }
    expect({position: 'value'}[const Position(x: -2, y: 3)], 'value');
  });

  test('sizes have value equality and work as map keys', () {
    // Exercise value equality between distinct, non-canonical instances.
    // ignore: prefer_const_constructors
    final size = Size(width: 4, height: 5);
    expect(size, const Size(width: 4, height: 5));
    for (final other in const [
      Size(width: 5, height: 5),
      Size(width: 4, height: 6),
    ]) {
      expect(size, isNot(other));
    }
    expect({size: 'value'}[const Size(width: 4, height: 5)], 'value');
    expect(size, isNot(const Position(x: 4, y: 5)));
  });

  test('rectangles compare all four values and work as map keys', () {
    // Exercise value equality between distinct, non-canonical instances.
    // ignore: prefer_const_constructors
    final rect = Rect(left: -2, top: 3, width: 4, height: 5);
    expect(rect, const Rect(left: -2, top: 3, width: 4, height: 5));
    for (final other in const [
      Rect(left: -1, top: 3, width: 4, height: 5),
      Rect(left: -2, top: 4, width: 4, height: 5),
      Rect(left: -2, top: 3, width: 5, height: 5),
      Rect(left: -2, top: 3, width: 4, height: 6),
    ]) {
      expect(rect, isNot(other));
    }
    expect({rect: 'value'}[const Rect(left: -2, top: 3, width: 4, height: 5)],
        'value');
    expect(rect, isNot(const Size(width: 4, height: 5)));
  });

  test('rectangles expose corners and round-trip through position and size',
      () {
    const rect = Rect(left: -10, top: -20, width: 30, height: 50);
    expect(rect.right, 20);
    expect(rect.bottom, 30);
    expect(rect.topLeft, const Position(x: -10, y: -20));
    expect(rect.topRight, const Position(x: 20, y: -20));
    expect(rect.bottomLeft, const Position(x: -10, y: 30));
    expect(rect.bottomRight, const Position(x: 20, y: 30));
    expect(rect.size, const Size(width: 30, height: 50));
    expect(Rect.from(topLeft: rect.topLeft, size: rect.size), rect);
  });

  test('negative dimensions clamp independently in runtime constructors', () {
    for (final (width, height, expected) in [
      (-1, 5, const Size(width: 0, height: 5)),
      (4, -1, const Size(width: 4, height: 0)),
      (-1, -1, const Size(width: 0, height: 0)),
      (0, 0, const Size(width: 0, height: 0)),
    ]) {
      expect(Size(width: width, height: height), expected);
      final rect = Rect(left: -2, top: -3, width: width, height: height);
      expect(rect.size, expected);
      expect(rect.topLeft, const Position(x: -2, y: -3));
      expect(rect, Rect.from(topLeft: rect.topLeft, size: expected));
    }
  });

  test('negative dimensions also clamp in const constructors', () {
    const size = Size(width: -1, height: -2);
    const rect = Rect(left: -2, top: -3, width: -1, height: -2);
    expect(size, const Size(width: 0, height: 0));
    expect(rect.size, size);
    expect(rect.bottomRight, rect.topLeft);
  });
}
