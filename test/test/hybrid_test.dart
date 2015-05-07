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

@TestOn("browser")
library webdriver.test.hybrid_test;

import 'dart:html';

import 'package:webdriver/core.dart' hide createDriver;
import 'package:webdriver/test/hybrid.dart';
import 'package:test/test.dart';

main() {
  group('Hybrid testing framework', () {
    WebDriver driver;
    var textChange = [];
    var text;
    var button;

    setUp(() async {
      textChange.clear();
      driver = await createDriver();
      if (document.querySelector('[wd-element-id="root"]') == null) {
        var div = new Element.div()..attributes['wd-element-id'] = 'root';
        button = new ButtonElement()
          ..attributes['wd-element-id'] = 'button'
          ..value = 'Button';
        text = new TextInputElement()..attributes['wd-element-id'] = 'text';

        button.onClick.listen((_) => text.value = '');
        text.onInput.listen(textChange.add);
        text.onChange.listen(textChange.add);
        div
          ..append(button)
          ..append(text);
        document.body.append(div);
      }
    });

    test('typing sends key events', () async {
      await driver.postRequest('element/text/value', {'value': ['some keys']});
      expect(textChange, hasLength(greaterThan(0)));
      expect(text.value, 'some keys');
      var length = textChange.length;
      await driver.postRequest('element/text/clear');
      expect(textChange, hasLength(greaterThan(length)));
      expect(text.value, '');
    });

    test('clicking works', () async {
      text.value = 'some keys';
      await driver.postRequest('element/button/click');
      expect(text.value, '');
    });
  });
}
