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

import '../common.dart' show By;

/// Here we massage [By] instances into viable W3C /element requests.
///
/// In principle, W3C spec implementations should be nearly the same as
/// the existing JSON wire spec. In practice compliance is uneven.
Map<String, String> byToJson(By by) {
  var using;
  var value;

  switch (by.using) {
    case 'id': // This doesn't exist in the W3C spec.
      using = 'css selector';
      value = '#${by.value}';
      break;
    case 'tag name': // This is in the W3C spec, but not in geckodriver.
      using = 'css selector';
      value = by.value;
      break;
    // xpath, css selector, link text, partial link text, seem fine.
    default:
      using = by.using;
      value = by.value;
  }

  return {'using': using, 'value': value};
}
