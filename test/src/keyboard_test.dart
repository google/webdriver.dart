library webdriver_test.keyboard;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';
import '../test_util.dart';

void main() {
  group('Keyboard', () {
    WebDriver driver;
    WebElement textInput;

    setUp(() async {
      driver = await WebDriver.createDriver(
          desiredCapabilities: Capabilities.firefox);
      await driver.get(testPagePath);
      textInput =
          await driver.findElement(const By.cssSelector('input[type=text]'));
      await textInput.click();
    });

    tearDown(() => driver.quit());

    test('sendKeys -- once', () async {
      await driver.keyboard.sendKeys('abcdef');
      expect(await textInput.attributes['value'], 'abcdef');
    });

    test('sendKeys -- twice', () async {
      await driver.keyboard.sendKeys('abc');
      await driver.keyboard.sendKeys('def');
      expect(await textInput.attributes['value'], 'abcdef');
    });

    test('sendKeys -- with tab', () async {
      await driver.keyboard.sendKeys('abc${Keys.TAB}def');
      expect(await textInput.attributes['value'], 'abc');
    });
  });
}
