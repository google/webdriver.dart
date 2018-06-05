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

/// Interacts with windows.
abstract class Windows {
  /// Get the current active window.
  Window get activeWindow;

  /// Get all windows.
  List<Window> get allWindows;
}

/// Handle to window.
///
/// Upon use, the window will automatically be set as active.
abstract class Window {
  /// The size of the window.
  Rectangle<int> get size;

  /// The location of the window.
  Point<int> get location;

  /// The location and size of the window.
  Rectangle<int> get rect;

  /// The location and size of the window.
  set rect(Rectangle<int> location);

  /// Maximize the window.
  void maximize();

  /// Set the window size.
  void setSize(Rectangle<int> size);

  /// Set the window location.
  void setLocation(Point<int> point);

  /// Sets the window as active.
  void setAsActive();
}
