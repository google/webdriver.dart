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

library webdriver.test.hybrid;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:webdriver/html.dart';

const _wdIdAttribute = 'wd-element-id';
const _frameId = 'frame-id';

Future<HybridDriver> createDriver() async {
  //throw "${window.location}";
  var path = p.join('/', p.split(window.location.pathname)[1], 'webdriver/');
  WebDriver driver = await fromExistingSession('1',
      uri: new Uri.http(
          '${window.location.hostname}:${window.location.port}', path));
  var hybrid = new HybridDriver(driver);
  await hybrid.switchToCurrentFrame();
  return hybrid;
}

class HybridDriver {
  final WebDriver _driver;

  HybridDriver(this._driver);

  static int _nextId = 0;

  /// Allow methods to work on elements in Shadow DOMs.
  /// Requires browser support the /deep/ selector combinator.
  Future enableShadowDomSupport() async {
    await _driver.postRequest('enabledeep');
  }

  /// Disallow methods to work on elements in Shadow DOMs.
  Future disableShadowDomSupport() async {
    await _driver.postRequest('disabledeep');
  }

  /// Makes the current frame the active frame for WebDriver, making sure that
  /// frame is visible.
  /// Will only work if the current frame is the top-level browser context of
  /// the current window or an iframe in the top-level browser context.
  Future switchToCurrentFrame() async {
    var element = document.querySelector('[$_wdIdAttribute="$_frameId"]');
    if (element == null) {
      element = new Element.div()
        ..attributes[_wdIdAttribute] = _frameId
        ..text = new Random().nextInt(1024).toString();
      document.body.append(element);
    }
    var id = element.text.trim();
    await _driver.postRequest('findframe/$id');
  }

  /// Clicks on [element].
  Future click(Element element) async {
    await _driver.postRequest('element/${_elementId(element)}/click');
  }

  /// Type into the [element] (or the currently focused element if [element]
  /// not provided).
  Future sendKeys(String keys, {Element element}) async {
    if (element != null) {
      await _driver.postRequest(
          'element/${_elementId(element)}/value', {'value': [keys]});
    } else {
      await _driver.keyboard.sendKeys(keys);
    }
  }

  /// Clear the value of [element].
  Future clear(Element element) async {
    await _driver.postRequest('element/${_elementId(element)}/clear');
  }

  /// See [Mouse.moveTo].
  Future moveMouseTo({Element element, int xOffset, int yOffset}) async {
    var params = {};
    if (element != null) {
      params['element'] = _elementId(element);
    }
    if (xOffset != null) {
      params['xoffset'] = xOffset.ceil();
    }
    if (yOffset != null) {
      params['yoffset'] = yOffset.ceil();
    }
    await _driver.postRequest('moveto', params);
  }

  /// See [Mouse.down].
  Future mouseDown(int button) async {
    await _driver.mouse.down(button);
  }

  /// See [Mouse.up].
  Future mouseUp(int button) async {
    await _driver.mouse.up(button);
  }

  /// Take a screenshot and save it to [filename].
  Future screenshot(String filename) async {
    await _driver.postRequest('screenshot', {'file': filename});
  }

  /// Capture the current page source and save it to [filename].
  Future sourceDump(String filename) async {
    await _driver.postRequest('source', {'file': filename});
  }

  String _elementId(Element element) {
    var elementId = element.attributes[_wdIdAttribute];
    if (elementId == null) {
      elementId = 'element-${_nextId++}';
      element.attributes[_wdIdAttribute] = elementId;
    }
    return elementId;
  }
}
