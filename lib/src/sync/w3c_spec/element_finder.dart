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

import 'web_element.dart';

import '../common.dart';
import '../web_driver.dart';
import '../web_element.dart';

/// Handles logic for finding elements in both WebDriver and element contexts.
class ElementFinder {
  final WebDriver _driver;
  final SearchContext _context;
  final Resolver _resolver;

  ElementFinder(this._driver, this._resolver, this._context);

  /// Here we massage [By] instances into viable W3C /element requests.
  ///
  /// In principle, W3C spec implementations should be nearly the same as
  /// the existing JSON wire spec. In practice compliance is uneven.
  Map<String, String> _byToJson(By by) {
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

  List<WebElement> findElements(By by) => _findElements(by, 'elements');

  WebElement findElement(By by) => _findElements(by, 'element')[0];

  List<String> _unwrapReponse(Map<String, String> response) => response.values;

  List<WebElement> _findElements(By by, String command) {
    final elements = _unwrapReponse(_resolver.post(command, _byToJson(by)));
    int i = 0;

    final webElements = new List<W3cWebElement>();
    for (final element in elements) {
      webElements.add(new W3cWebElement(_driver, element, _context, by, i++));
    }
    return webElements;
  }
}
