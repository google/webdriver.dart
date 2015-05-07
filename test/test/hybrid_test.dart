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
