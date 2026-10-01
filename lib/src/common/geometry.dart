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

/// A position in a two-dimensional coordinate space with integer coordinates.
///
/// The [x] coordinate increases to the right and
/// the [y] coordinate increases downward.
/// Either coordinate can be negative,
/// such as for a window positioned partially off screen.
///
/// Two positions are considered equal if
/// they have the same [x] and [y] coordinates.
final class Position {
  /// The horizontal coordinate, which increases to the right.
  final int x;

  /// The vertical coordinate, which increases downward.
  final int y;

  /// Creates a position at the specified [x] and [y] coordinates.
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

/// An axis-aligned rectangle with integer coordinates and dimensions.
///
/// A rectangle is defined by the position of its top-left corner,
/// ([left], [top]), and its [width] and [height].
/// Coordinates increase to the right and downward,
/// so [right] and [bottom] are never less than [left] and [top].
///
/// The [left] and [top] coordinates can be negative,
/// but [width] and [height] are never negative.
///
/// Two rectangles are considered equal if they have the same position and size.
final class Rect {
  /// The x-coordinate of the left edge of this rectangle.
  final int left;

  /// The y-coordinate of the top edge of this rectangle.
  final int top;

  /// The distance between the [left] and [right] edges of this rectangle,
  /// which is never negative.
  final int width;

  /// The distance between the [top] and [bottom] edges of this rectangle,
  /// which is never negative.
  final int height;

  /// Creates a rectangle with its top-left corner at ([left], [top])
  /// and the specified [width] and [height].
  ///
  /// Negative [width] and [height] values are clamped to zero.
  const Rect({
    required this.left,
    required this.top,
    required int width,
    required int height,
  })  : width = (width < 0) ? 0 : width,
        height = (height < 0) ? 0 : height;

  /// Creates a rectangle with its top-left corner at [topLeft]
  /// and the dimensions of [size].
  factory Rect.from({required Position topLeft, required Size size}) => Rect(
        left: topLeft.x,
        top: topLeft.y,
        width: size.width,
        height: size.height,
      );

  /// The [width] and [height] of this rectangle, without its position.
  Size get size => Size(width: width, height: height);

  /// The x-coordinate of the right edge of this rectangle.
  ///
  /// This is equal to [left] plus [width].
  int get right => left + width;

  /// The y-coordinate of the bottom edge of this rectangle.
  ///
  /// This is equal to [top] plus [height].
  int get bottom => top + height;

  /// The position of the top-left corner of this rectangle,
  /// at ([left], [top]).
  Position get topLeft => Position(x: left, y: top);

  /// The position of the top-right corner of this rectangle,
  /// at ([right], [top]).
  Position get topRight => Position(x: right, y: top);

  /// The position of the bottom-right corner of this rectangle,
  /// at ([right], [bottom]).
  Position get bottomRight => Position(x: right, y: bottom);

  /// The position of the bottom-left corner of this rectangle,
  /// at ([left], [bottom]).
  Position get bottomLeft => Position(x: left, y: bottom);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rect &&
          left == other.left &&
          top == other.top &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => Object.hash(left, top, width, height);

  @override
  String toString() =>
      'Rect(left: $left, top: $top, width: $width, height: $height)';
}

/// The integer width and height of a two-dimensional area,
/// such as an element or a browser window.
///
/// Unlike a [Rect], a size has no position.
/// [width] and [height] are never negative.
///
/// Two sizes are considered equal if they have the same [width] and [height].
final class Size {
  /// The horizontal dimension, which is never negative.
  final int width;

  /// The vertical dimension, which is never negative.
  final int height;

  /// Creates a size with the specified [width] and [height].
  ///
  /// Negative [width] and [height] values are clamped to zero.
  const Size({required int width, required int height})
      : width = (width < 0) ? 0 : width,
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
