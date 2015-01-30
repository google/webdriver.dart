library webdriver_test.mouse;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

import '../test_util.dart';

void main() {
  group('Mouse', () {
    WebDriver driver;
    WebElement button;

    setUp(() async {
      driver = await createTestDriver();
      await driver.get(testPagePath);
      button = await driver.findElement(new By.tagName('button'));
    });

    tearDown(() => driver.quit());

    test('moveTo element/click', () async {
      await driver.mouse.moveTo(element: button);
      await driver.mouse.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    test('moveTo coordinates/click', () async {
      var pos = await button.location;
      await driver.mouse.moveTo(xOffset: pos.x + 5, yOffset: pos.y + 5);
      await driver.mouse.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    test('moveTo element coordinates/click', () async {
      await driver.mouse.moveTo(element: button, xOffset: 5, yOffset: 5);
      await driver.mouse.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    // TODO(DrMarcII): Better up/down tests
    test('down/up', () async {
      await driver.mouse.moveTo(element: button);
      await driver.mouse.down();
      await driver.mouse.up();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    // TODO(DrMarcII): Better double click test
    test('doubleClick', () async {
      await driver.mouse.moveTo(element: button);
      await driver.mouse.doubleClick();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });
  });
}
