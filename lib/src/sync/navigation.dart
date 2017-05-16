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

import 'common.dart';

class Navigation extends WebDriverBase {
  Navigation(driver) : super(driver, '');

  ///  Navigate forwards in the browser history, if possible.
  void forward() {
    post('forward');
  }

  /// Navigate backwards in the browser history, if possible.
  void back() {
    post('back');
  }

  /// Refresh the current page.
  void refresh() {
    post('refresh');
  }

  @override
  String toString() => '$driver.navigate';

  @override
  int get hashCode => driver.hashCode;

  @override
  bool operator ==(other) => other is Navigation && other.driver == driver;
}
