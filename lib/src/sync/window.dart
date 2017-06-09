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
  @Deprecated('JSON wire legacy support, emulated for newer browsers')
  Rectangle<int> get size;

  /// The location of the window.
  @Deprecated('JSON wire legacy support, emulated for newer browsers')
  Point<int> get location;

  /// The location and size of the window.
  Rectangle<int> get rect;

  /// The location and size of the window.
  void set rect(Rectangle<int> location);

  /// Maximize the window.
  void maximize();

  /// Set the window size.
  @Deprecated('JSON wire legacy support, emulated for newer browsers')
  void setSize(Rectangle<int> size);

  /// Set the window location.
  @Deprecated('JSON wire legacy support, emulated for newer browsers')
  void setLocation(Point<int> point);

  /// Sets the window as active.
  void setAsActive();

  @override
  bool operator ==(other);
}
