// Copyright 2025 Google Inc. All Rights Reserved.
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

/// A two-dimensional location represented by [x] and [y] coordinates on
/// a 2D-coordinate system where the origin `(0, 0)` is in the top-left corner.
final class Position {
  /// The x-coordinate of this position.
  final int x;

  /// The y-coordinate of this position.
  final int y;

  /// Create a location at the specified [x] and [y] coordinates.
  const Position({required this.x, required this.y});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Position(x: $x, y: $y)';
}

/// A rectangle, which is a quadrilateral with four right angles, represented on
/// a 2D-coordinate system where the origin `(0, 0)` is in the top-left corner.
final class Rect {
  final int _left;
  final int _top;
  final int _width;
  final int _height;

  /// Create a rectangle with its upper-left corner at `(left, top)`
  /// and its bottom right corner at `(left + width, top + height)`.
  ///
  /// [width] and [height] should both be non-negative.
  /// If they aren't, they are clamped to zero.
  const Rect({
    required int left,
    required int top,
    required int width,
    required int height,
  })  : assert(width >= 0, height >= 0),
        _top = top,
        _left = left,
        _width = (width < 0) ? 0 : width,
        _height = (height < 0) ? 0 : height;

  /// Create a rectangle with its upper-left corner at `(topLeft.x, topLeft.y)`
  /// and its bottom right corner at `(topLeft.x + width, topLeft.y + height)`.
  ///
  /// The `width` and `height` of [Size] should both be non-negative.
  factory Rect.from({required Position topLeft, required Size size}) => Rect(
        left: topLeft.x,
        top: topLeft.y,
        width: size.width,
        height: size.height,
      );

  /// The width of this rectangle.
  int get width => _width;

  /// The height of this rectangle.
  int get height => _height;

  /// The size of this rectangle.
  Size get size => Size(width: _width, height: _height);

  /// The x-coordinate of the left edge of this rectangle.
  int get left => _left;

  /// The y-coordinate of the top edge of this rectangle.
  int get top => _top;

  /// The x-coordinate of the right edge of this rectangle.
  int get right => _left + _width;

  /// The x-coordinate of the bottom edge of this rectangle.
  int get bottom => _top + _height;

  /// The location of the top-left corner of this rectangle.
  Position get topLeft => Position(x: left, y: top);

  /// The location of the top-right corner of this rectangle.
  Position get topRight => Position(x: right, y: top);

  /// The location of the bottom-right corner of this rectangle.
  Position get bottomRight => Position(x: right, y: bottom);

  /// The location of the bottom-left corner of this rectangle.
  Position get bottomLeft => Position(x: left, y: bottom);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rect &&
          _left == other._left &&
          _top == other._top &&
          _width == other._width &&
          _height == other._height;

  @override
  int get hashCode => Object.hash(_left, _top, _width, _height);

  @override
  String toString() =>
      'Rect(left: $_left, top: $_top, width: $_width, height: $_height)';
}

/// The width and height dimensions of a 2D object.
final class Size {
  /// The width dimension.
  final int width;

  /// The height dimension.
  final int height;

  /// Create a size that represents the
  /// specified [width] and [height] dimensions.
  ///
  /// [width] and [height] should both be non-negative.
  /// If they aren't, they are clamped to zero.
  const Size({required int width, required int height})
      : assert(width >= 0, height >= 0),
        width = (width < 0) ? 0 : width,
        height = (height < 0) ? 0 : height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Size && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() => 'Size(width: $width, height: $height)';
}
